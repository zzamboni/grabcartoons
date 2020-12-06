#!/bin/sh
eval 'exec perl -x $0 ${1+"$@"}' # -*-perl-*-
  if 0;
#!perl -w
#
# Grab daily cartoons from their web sites.
# http://zzamboni.org/grabcartoons/
#

use FindBin;
use Getopt::Long;
use File::Path;

use Env qw(HOME GRABCARTOONS_DIRS);

$VERSION="2.8.4";

Getopt::Long::Configure ("bundling");

@GRABCARTOONS_DIRS=split(/:/, $GRABCARTOONS_DIRS||"");

######################################################################
# Configuration section

# What to use: 0 - autoselect, 1 - external command, 2 - LWP::UserAgent
$GET_METHOD=0;

# Command to get a web page and print it to stdout, if $GET_METHOD=2
# or you don't have LWP::UserAgent installed
# This program must be in your path, otherwise change $XTRN_PROG to
# include the full path.
$XTRN_PROG="wget";
#$USER_AGENT=""; # uncomment the following line if you have problems
$USER_AGENT="Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/521.25 (KHTML, like Gecko) Safari/521.24";
$USER_AGENT_CMD = $USER_AGENT ? qq(-U "$USER_AGENT") : "" ;
# TODO - add in other user-agent strings if needed
$XTRN_CMD="$XTRN_PROG -q -O- $USER_AGENT_CMD";

# Where to load cartoon modules from
@MODULE_DIRS=("$FindBin::Bin/modules",
              "$FindBin::RealBin/modules",
              "$FindBin::Bin/../lib/grabcartoons/modules",
              "$FindBin::RealBin/../lib/grabcartoons/modules",
              "$HOME/.grabcartoons/modules",
              "$HOME/.grabcartoons",
              @GRABCARTOONS_DIRS,
             );

# Verbosity flag
$verbose=0;

# Where to write generated modules
$genout="$HOME/.grabcartoons/modules";

# Avoid CA errors in some versions of LWP, see
# https://fastapi.metacpan.org/source/GAAS/libwww-perl-6.00/Changes
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = "0";

# End config section
######################################################################

$versiontext="GrabCartoons version $VERSION";
$usage="$versiontext
Usage: $0 [ options ] [ comic_id ...]
    --all       or -a  generate a page with all the known comics on stdout.
    --list [t:] or -l  produce a list of the known comic_id's on stdout. If
                       t: is given, the list of comics from the given template
                       is produced.
    --htmllist [t:]    produce HTML list of known comic_id's on stdout. If
                       t: is given, the list of comics from the given template
                       is produced.
    --file     or -f   read list of comics from specified file.
    --random n         select n comics at random (they will be output after
                       any other comics requested)
    --write    or -w   write output to specified file instead of stdout.
    --version  or -V   print version number
    --verbose  or -v   be verbose
    --help     or -h   print this message.
    --notitles or -t   do not show comic titles (for those that have them)
    --templates        produce a list of defined templates
    --genmodules       for any template specifications (template:comictag),
                       write a snippet to comictag.pl in the directory
                       specified by --genout.
    --genout dir       output directory for generated comics.
                       (default: $genout)

By default, it will produce a page with the given comics on stdout.

comic_id can be:
  - Any of the predefined modules (e.g. sinfest, adam_at_home)
  - Of the form 'template:comic title', including quotes if the title has
    spaces (e.g. 'gocomis.com:Citizen Dog', comics.com:Frazz). This will
    generate on the fly a module for the given comic.
  - Of the form 'template:*' or 'template:', which means \"all the comics
    from the named template\". This can also be passed as argument to
    the --list and --htmllist options to produce the listing from the
    given template instead of from the built-in modules.
";
$doall=0;
$dolist=0;
$listoftemplates=0;
$file=undef;
$output=undef;
$notitles=0;
$random=0;
$allerrors="";
$genmodules=0;

# Process options
GetOptions(
           'all|a'     => \$doall,
           'list|l'    => \$dolist,
           'htmllist'  => \$htmllist,
           'f|file=s'  => \$file,
           'w|write=s' => \$output,
           'verbose|v' => \$verbose,
           'notitles|t'=> \$notitles,
           'templates' => \$listoftemplates,
           'random=i'  => \$random,
           'genmodules'=> \$genmodules,
           'genout=s'  => \$genout,
           'version|V' =>
           sub {
             print "$versiontext\n";
             exit;
           },
           'help|h' =>
           sub {
             print $usage;
             exit;
           },
          );

# Check get method
if ($GET_METHOD == 0) {
  vmsg("Determining which method to use for grabbing URLs...\n");
  eval 'use LWP::UserAgent';
  if ($@) {
    vmsg("Couldn't find LWP::UserAgent, trying $XTRN_PROG...\n");
    if (system("$XTRN_PROG --help >/dev/null 2>/dev/null") == 0) {
      $GET_METHOD=1;
      vmsg("Using $XTRN_PROG.\n");
    } else {
      die "Error: I couldn't find LWP::UserAgent nor $XTRN_PROG\n";
    }
  } else {
    $GET_METHOD=2;
    vmsg("Found LWP::UserAgent.\n");
  }
} elsif ($GET_METHOD == 2) {
  vmsg("Loading LWP::UserAgent...\n");
  eval 'use LWP::UserAgent';
}

# If --genmodules is requested, check that --genout is a directory
# or can be created as one
if ($genmodules) {
  vmsg("The --genmodules option was specified, checking output directory '$genout'\n");
  if (-e $genout) {
    if (-d $genout) {
      vmsg("  Good. $genout is an existing directory.\n");
    } else {
      die "Error: specified output directory '$genout' exists but is not a directory.\n";
    }
  } else {
    # Try to create it
    vmsg("  Directory does not exist - creating...");
    if (mkpath($genout)) {
      vmsg(" success!\n");
    } else {
      vmsg(" failure.\n");
      die "Error: could not create output directory '$genout': $!\n";
    }
  }
}
# Eliminate duplicates in @MODULE_DIRS (in most cases Bin and RealBin
# will be the same)
%mod_seen=();
@MODULE_DIRS = grep { ! $mod_seen{$_} ++ } @MODULE_DIRS;

vmsg("Scanning module directories...\n");
# Load modules
foreach $mdir (@MODULE_DIRS) {
  if (-d $mdir) {
    vmsg("Loading modules in directory $mdir... ");
    opendir MDIR, $mdir
      or die "Error opening directory $mdir: $!\n";
    @mods=grep { /\.pl$/ && -f "$mdir/$_" } readdir(MDIR);
    closedir MDIR;
    foreach (@mods) {
      vmsg("$_ ");
      require "$mdir/$_";
    }
    vmsg("\n");
  }
}

@list_of_modules=keys %COMIC;
@list_of_templates=keys %TEMPLATE;

# Scan for CSS files
vmsg("Scanning for CSS files...\n");
$OUTPUTCSS = "";
foreach $mdir (@MODULE_DIRS) {
  if (-d $mdir) {
    vmsg("Loading CSS files in directory $mdir... ");
    opendir MDIR, $mdir
      or die "Error opening directory $mdir: $!\n";
    @cssfiles=grep { /\.css$/ && -f "$mdir/$_" } readdir(MDIR);
    closedir MDIR;
    foreach (@cssfiles) {
      vmsg("$_ ");
      $filename = "$mdir/$_";
      open(FILE, "<",  $filename) or die "Error opening CSS file $filename: $!\n";
      $OUTPUTCSS = $OUTPUTCSS . "/* $filename */\n";
      $OUTPUTCSS = $OUTPUTCSS . join('', <FILE>);
    }
    vmsg("\n");
  }
}

# Scan for JavaScript files
vmsg("Scanning for JavaScript files...\n");
$OUTPUTJS = "";
foreach $mdir (@MODULE_DIRS) {
  if (-d $mdir) {
    vmsg("Loading JS files in directory $mdir... ");
    opendir MDIR, $mdir
      or die "Error opening directory $mdir: $!\n";
    @jsfiles=grep { /\.js$/ && -f "$mdir/$_" } readdir(MDIR);
    closedir MDIR;
    foreach (@jsfiles) {
      vmsg("$_ ");
      $filename = "$mdir/$_";
      open(FILE, "<",  $filename) or die "Error opening js file $filename: $!\n";
      $OUTPUTJS = $OUTPUTJS . "/* $filename */\n";
      $OUTPUTJS = $OUTPUTJS . join('', <FILE>);
    }
    vmsg("\n");
  }
}

# Scan for Header include files
vmsg("Scanning for Header include files...\n");
$OUTPUTHEAD = "";
foreach $mdir (@MODULE_DIRS) {
  if (-d $mdir) {
    vmsg("Loading *.head files in directory $mdir... ");
    opendir MDIR, $mdir
      or die "Error opening directory $mdir: $!\n";
    @headfiles=grep { /\.head$/ && -f "$mdir/$_" } readdir(MDIR);
    closedir MDIR;
    foreach (@headfiles) {
      vmsg("$_ ");
      $filename = "$mdir/$_";
      open(FILE, "<",  $filename) or die "Error opening head file $filename: $!\n";
      $OUTPUTHEAD = $OUTPUTHEAD . "<!-- $filename -->\n";
      $OUTPUTHEAD = $OUTPUTHEAD . join('', <FILE>);
    }
    vmsg("\n");
  }
}

$lom="Comic IDs defined:\n\t".join("\n\t", sort @list_of_modules)."\n";
$htmlhdr="";

if ($dolist && !@ARGV) {
  print $lom;
  exit;
}
if ($listoftemplates) {
  print "Templates defined:\n\t".join("\n\t", map { $_ . "\t" . $TEMPLATE{$_}->{_Template_Description}||"" } sort @list_of_templates)."\n";
  exit;
}

if ($htmllist) {
  # List defined modules, but in HTML
  @ARGV=sort @list_of_modules unless @ARGV;
}

if ($doall) {
  # Generate all cartoons
  @ARGV=sort @list_of_modules;
}

# Read the comics from a file if desired
if ( $file ) {
  open COMICS, $file or die "can't open $file: $!\n";
  @ARGV = <COMICS>;
  close COMICS;
  # we allow comments and spaces
  s/^\s+// for @ARGV;
  s/\s+$// for @ARGV;
  s/\s+/_/g for @ARGV;
  @ARGV = grep !/^#/, @ARGV;
}

# Normalize before random selection, otherwise we might
# end up with duplicate comics
my @normalized_comics=();
vmsg("Normalizing list of requested comics...\n");
foreach my $comic (@ARGV) {
  # If it's a template:comic pair, leave it alone, templates do their own normalization
  if ($comic =~ /^.+:.*$/) {
    vmsg("  $comic is a template:comic pair, leaving unmodified.\n");
    push @normalized_comics, $comic;
    next;
  }
  my $title=lc($comic);
  # First, try the name as given
  if (exists($COMIC{$title})) {
    vmsg("  $title found as a valid comic tag\n");
    push @normalized_comics, $title;
    next;
  }
  # Next, search for it in the titles
  my $tag=(grep { lc($COMIC{$_}->{Title}) eq $title } keys(%COMIC))[0];
  if ($tag) {
    vmsg("  $comic found by searching comic titles\n");
    push @normalized_comics, $tag;
    next;
  }
  # Finally, try the old generic normalization - replace all non-alphanumeric characters with underscores
  vmsg("  $comic not found - trying generic normalization\n");
  $tag=$title;
  $tag=~s/\W+/_/g;
  if (exists($COMIC{$tag})) {
    vmsg("  $comic found as tag $tag\n");
    push @normalized_comics, $tag;
    next;
  } else {
    error("[$comic] Error: I do not know '$comic' - skipping it\n");
    next;
  }
}
@ARGV=@normalized_comics;

# If random comics were requested, choose them
if ($random) {
  vmsg("Choosing $random random comics... ");
  for my $c (@ARGV) {
    $COMIC{$c}->{__chosen} = 1 if exists($COMIC{$c});
  }
  while ($random) {
    my $cnum=int(rand(scalar(@list_of_modules)));
    my $cname=$list_of_modules[$cnum];
    if (!($COMIC{$cname}->{__chosen})) {
      push @ARGV, $cname;
      $COMIC{$cname}->{__chosen} = 1;
      $random--;
      vmsg("$cname ");
    }
  }
  vmsg("\n");
}

if (!@ARGV) {
  print $usage;
  exit;
}

# output to a file if desired
if ( $output ) {
  open STDOUT, ">$output" or die "can't write to file $output: $!\n";
}


if ($htmllist) {
  &print_header_htmllist($htmlhdr);
} else {
  &print_header unless $dolist;
}

# Finally, get the comics
vmsg("Getting cartoons...\n");
foreach $name (@ARGV) {
  my ($templ, $comic)=split(/:/, $name, 2);
  # If the given name is of the form template:cartoon and the template
  # is valid, generate a $COMIC snippet on the fly
  if (defined($templ) && defined($comic)) {
    if (defined($TEMPLATE{$templ})) {
      vmsg("  Generating module for '$comic' on the fly, using template '$templ'\n");
      $C={};
      $C->{Title} = $comic;
      $C->{Template} = $templ;
    } else {
      error("[$name] Error: I do not know template '$templ'\n");
      next;
    }
  } else {
    vmsg("  Getting $name.\n");
    if (!exists($COMIC{$name})) {
      error("[$name] Error: I do not know '$name'\n");
      next;
    }
    $C=$COMIC{$name};
  }

  undef($err);
  $title=undef;
  @Clist=();

  if ($C->{Template}) {
    unless ($TEMPLATE{$C->{Template}}) {
      error("[$name] Internal Error: the requested template '$C->{Template}' does not exist.\n");
      next;
    }
    # If _Init_Code exists, execute it with the template snippet AND
    # the (still unmerged) comic snippet as arguments, and delete it
    # afterward only if the function returns a true value. This is
    # meant to allow the template to execute one-time initialization
    # code (e.g. get list of comics from the web site). The
    # conditional deletion allows initialization to be deferred
    # depending on the specifics of the comic snippet, for
    # example. The code can store any data in the hash it receives as
    # argument, and that data will be available for all other uses of
    # the template in the current run.
    if (exists($TEMPLATE{$C->{Template}}->{_Init_Code})) {
      ($title,$err)=$TEMPLATE{$C->{Template}}->{_Init_Code}->($TEMPLATE{$C->{Template}}, $C);
      if ($err) {
        goto CHECKERROR;
      }
      delete($TEMPLATE{$C->{Template}}->{_Init_Code});
    }
    # If Title is * or empty, then produce a list with all known comics in the template.
    if ($C->{Title} eq '*' || $C->{Title} eq '') {
      $loc=$TEMPLATE{$C->{Template}}->{_Comics};
      if (scalar keys %$loc) {
        vmsg("All comics requested for template $C->{Template}\n");
        print "List of comic IDs known in template $C->{Template}:\n" if ($dolist);
        foreach $comic (sort keys %$loc) {
          push @Clist, { Tag => $comic, Template => $C->{Template} };
          print "\t$comic ($loc->{$comic})\n" if $dolist;
        }
        exit if $dolist;
      } else {
        ($title, $err)=($C->{Title}, "I do not know the list of comics for template $C->{Template}");
        goto CHECKERROR;
      }
    } else {
      @Clist = ( $C );
    }
    foreach $C2 (@Clist) {
      # Next, merge the fields of the comic's hash with the template hash
      my %tmpl=%{$TEMPLATE{$C2->{Template}}};
      my ($k,$v);
      my %oldC=%$C2;
      while (($k,$v) = each(%tmpl)) {
        $C2->{$k}=$v;
      }
      while (($k,$v) = each(%oldC)) {
        $C2->{$k}=$v;
      }
      # Determine the comic's tag if needed
      ($title,$err)=find_and_validate_template_tag($C2);
      goto CHECKERROR if $err;
      # If _Template_Code exists, execute it with the merged snippet as argument,
      # and delete it from the merged snippet
      if ($tmpl{_Template_Code}) {
        delete($C2->{_Template_Code});
        ($title,$err)=$tmpl{_Template_Code}->($C2);
        if ($err) {
          goto CHECKERROR;
        }
      }
      # If requested, write out the new module
      if ($genmodules) {
        my $fname="$genout/$C2->{Tag}.pl";
        vmsg("[$name] Writing module to $fname\n");
        open MOD, ">$fname"
          or die "[$name] Error creating file $fname: $!\n";
        print MOD <<EOMODULE;
\$COMIC{'$C2->{Tag}'} = {
			Title => '$C2->{Title}',
			Tag => '$C2->{Tag}',
			Template => '$C2->{Template}',
};
EOMODULE
        close MOD;
      }
    }
  }

  @Clist = ( $C ) unless @Clist;

  foreach $C3 (@Clist) {
    # replace variable references
    for (keys(%$C3)) {
      $C3->{$_}=_replace_vars($C3->{$_}, $C3);
    }
    $mainurl=$C3->{Page};
    if ($htmllist) {
      &print_section_htmllist($name, $C3->{Title}||$name, $mainurl);
      next;
    }
    ($html, $title, $err)=get_comic($C3);
    &print_section($title, undef, $html, $mainurl, $err, $C3->{SkipLink});
    goto CHECKERROR if $err || !$html;
  }
 CHECKERROR:
  if ($err || (!$html && !$htmllist)) {
    if ($mainurl) {
      error("[$name] Error fetching $name [ $mainurl ]: $err\n");
      $err="Error fetching <a href=\"$mainurl\">$name</a>: $err";
    } else {
      $err="Error getting the URL for $name: $err";
      error("[$name] $err\n");
    }
  }
}

if ($htmllist) {
  &print_footer_htmllist;
} else {
  &print_footer;
}

# Print any errors
if ($allerrors) {
  warn "The following errors occurred:\n$allerrors";
}

# Get a URL, split in lines and store them for later fetching.
# If an error occurs, returns undef.
# Allows generalized redirection using the $redirect_* parameters.
# By default it follows the standard redirection using the META REFRESH
# tag, but can be used to redirect according to arbitrary pattern
# matching (e.g. see the oatmeal.pl module)
sub fetch_url {
  my $url=shift;
  my $force=shift;
  my $quiet=shift;
  my $redirect_match=shift || 'http-equiv="refresh"';
  my $redirect_urlcapture=shift || 'content="\d+;url=(.*?)"';
  my $redirect_urlprepend=shift || '';
  my $redirect_urlappend=shift || '';
  my $multiple_redirects=shift;
  # If we are just producing a list of URLs, give a bogus error unless $force is specified
  return undef if ($htmllist && !$force);
  vmsg("    Fetching $url... ");
  if ($GET_METHOD == 2) {
    my $ua=LWP::UserAgent->new;
    $ua->agent( $USER_AGENT );
    my $req=new HTTP::Request('GET',$url);
    my $resp=$ua->request($req);
    if ($resp->is_error) {
      $err="Could not retrieve $url : " . $resp->status_line ;
	    error("$err\n") unless $quiet;
      return undef;
    }
    my $html=$resp->content;
    # Split on lines and store
    @LINES=split("\n", $html);
    $_.="\n" foreach (@LINES);
  } elsif ($GET_METHOD == 1) {
    my $cmd="$XTRN_CMD '$url'";
    open CMD, "$cmd |" or do {
      $err="Error executing '$cmd': $!";
	    error("$err\n") unless $quiet;
      return undef;
    };
    @LINES=<CMD>;
    close CMD;
  } else {
    $err="Internal error: Invalid value of GET_METHOD ($GET_METHOD)";
    error("$err\n");
    return undef;
  }
  if ($redirect_match) {
    my @matches=grep(/$redirect_match/i, @LINES);
    if (@matches && $matches[0] =~ /$redirect_urlcapture/i) {
      my $newurl=$redirect_urlprepend . $1 . $redirect_urlappend;
      if ($multiple_redirects) {
        return fetch_url($newurl, $force, $quiet, $redirect_match, $redirect_urlcapture, $redirect_urlprepend, $multiple_redirects);
      } else {
        return fetch_url($newurl, $force, $quiet)
      }
    }
  }
  vmsg("success.\n");
  return 1;
}

# Get a line off the last url retrieved. Automatically stores it in $_
sub get_line {
  return $_=shift @LINES;
}

# Get the full page as a single string
sub get_fullpage {
  my $r=join("\n", @LINES);
  @LINES=();
  return $r;
}

# Setting @LINES to any array, for easier fetching later
sub set_lines {
  @LINES = @_;
}

# Print a message if verbose flag is on
sub vmsg {
  print STDERR @_ if $verbose;
}

# Replace references of the form {Name} with the
# value of the Name field, if it exists
sub _replace_vars {
  my $str=shift;
  my $vars=shift;
  my %v=%$vars;
  my $didsomething;
  do {
    $didsomething=undef;
    for my $k (keys %v) {
      if ($str=~s/\{$k\}/$v{$k}/g) {
        $didsomething=1;
      }
    }
  } while ($didsomething);
  return $str;
}

# Process a string according to the existence and value
# of SubstOnRegexResult.
sub _do_regex_replacements {
  my $s=shift;
  my $C=shift;
  if (exists($C->{SubstOnRegexResult})) {
    foreach my $tuple (@{$C->{SubstOnRegexResult}}) {
      my $repl = _replace_vars($tuple->[1], $C);
      if ($tuple->[2]) {
        $s =~ s!$tuple->[0]!$repl!g;
      } else {
        $s =~ s!$tuple->[0]!$repl!;
      }
    }
  }
  return $s;
}

sub find_and_validate_template_tag {
  $H=shift;
  # Make sure we have a valid tag
  $ch=$H->{_Comics} || {};
  # If a tag was manually set, respect it
  unless ($H->{Tag}) {
    # Otherwise, try to derive it from the comic's title
    my $title=lc($H->{Title});
    vmsg("    [tmpl:$H->{_Template_Name}] Trying to find the tag for '$title'\n");
    # First, see if the title is a valid tag already.
    if ($ch->{$title}) {
      # If so, store it as tag and replace the title with the appropriate comic name
      $H->{Tag}=$title;
      $H->{Title}=$ch->{$title};
      vmsg("      [tmpl:$H->{_Template_Name}] Done - comic title was the tag\n");
    } else {
      # Second, search for the title in the comics we know
      vmsg("      [tmpl:$H->{_Template_Name}] Looking for the comic's title '$title' in the list of comics\n");
      my $tag=(grep { $_ =~ /$title/i || $ch->{$_} =~ /$title/i } keys(%$ch))[0];
      # If that doesn't work, try some blind normalization
      if ($tag) {
        vmsg("      [tmpl:$H->{_Template_Name}] Found the title in the list of comics\n");
      } else {
        vmsg("      [tmpl:$H->{_Template_Name}] Title not found in comics list - trying some normalization\n");
        $tag=$title;
        $tag=~s/\s+\&\s+/&/g; $tag=~s/\.//g; $tag=~s/'//g; $tag=~s/\s/_/g;
      }
      $H->{Tag} = $tag;
    }
  }
  # Set the proper title if we can
  if (exists($ch->{$H->{Tag}})) {
    $H->{Title} = $ch->{$H->{Tag}};
  }

  # If we have a list of comics, check that the tag is valid
  if ((scalar keys %$ch) && !exists($ch->{$H->{Tag}})) {
    return($H->{Title}||$H->{_Template_Name}, "Could not find comic '$H->{Tag}' in template '$H->{_Template_Name}'");
  }
}

# Process a %COMIC snippet, passed as a hashref
# Return ($html, $title, $error)
# Valid fields:
#     Title   => title of the comic
#     Page    => URL where to get it
#     Regex   => regex to obtain image, must put the image in $1
#                   (the first parenthesized group)
#     LinkRelImageSrc => if true, the image URL will be automatically
#                obtained from the first <link rel="image_src"> element in
#                the page. This is increasingly being used by web comics
#                to ease sharing on Facebook and other sites. If this
#                flag is specified no Regex or other method needs to be
#                specified.
#     MultipleMatches => if true, then all matches of Regex will be
#                returned, concatenated, after doing any changes
#                specified by SubstOnRegexResult or Prepend/Append
#                on each element. If MultipleMatches is in effect,
#                then the result of $1 + SubstOnRegexResult + Prepend/Append
#                is expected to be an HTML snippet, not just an image URL.
#     ExtraImgAttrsRegex => regular expression to obtain additional
#                attributes of the comic's <img> tag. It has to
#                match on the same line that Regex matches. If not
#                specified, a generic text is used for the "alt"
#                image attribute.
#     TitleRegex => regular expression to capture the title of the
#                comic. It can match on any line _before_ Regex matches.
#                If it does not match, no title is displayed (just the comic name).
#                Only works for comics for which Regex is also defined.
#     SubstOnRegexResult => an array of two- or three-element array
#            references containing [ regex, string, [global] ]. If
#            specified, the substitution specified by each element
#            will be applied to the string captured by Regex or by
#            Start/EndRegex, before applying any Prepend/Append
#            strings.  Each tuple will be applied in the order they
#            are specified. If "global" is given and true, a global
#            replace will be done, otherwise only the first ocurrence
#            will be replaced.  The replacement string may include
#            other fields, referenced as {FieldName}.
#     Prepend/Append => strings to prepend or append to $1 (or to the string
#            captured by Start/EndRegex) before returning it. May make use of
#            other fields, referenced as {FieldName}
#     StartRegex/EndRegex => regular expressions that specify the first
#            and last lines to capture. The matching lines are included in
#            the output if InclusiveCapture == 1, and not included
#            if InclusiveCapture == 0 (the default).
#            If EndRegex is not specified, everything from StartRegex to
#            the end of the page is captured.
#            If Regex is also specified, it is only matched for inside the
#            region defined by StartRegex/EndRegex
#     InclusiveCapture => true/false value that specifies whether the lines
#            that match Start/EndRegex should be returned in the output. By
#            default InclusiveCapture == false.
#     RedirectMatch
#     RedirectURLCapture
#     RedirectURLAppend
#     RedirectURLPrepend
#     MultipleRedirects
#           These parameters control generalized redirection
#           support. By default, these parameters are set so that
#           standard redirection using the META REFRESH tag is
#           followed, but can be set to redirect on arbitrary
#           patterns. This is how it works: if the RedirectMatch regex
#           matches on any line of the page, then the
#           RedirectURLCapture pattern is applied to the same line,
#           and should contain one capture group which returns the new
#           URL to use. If RedirectURLAppend/Prepend are specified,
#           these strings are concatenated with the result of the
#           capture group before using it as the new URL. By default
#           the patterns are passed NOT along when fetching the new page,
#           to prevent infinite redirection. This behavior can be
#           modified by setting MultipleRedirects to a true value, so that
#           multiple redirects using the same parameters are
#           supported.
#     StaticURL => static image URL to return
#     StaticHTML => static HTML snippet to return
#     Function  => a function to call. It receives the commic snippet as
#           argument, and must return ($html, $title, $error)
#     NoShowTitle => if true, do not display the title of the comic
#           (for those that always have it in the drawing)
#     Template => if present, specified a template that will be used
#           for this comic (e.g. for comics coming from a single
#           syndicated site, so the mechanism is the same for all of them)
#           Essentially the fields from the template and the $COMIC snippet
#           are merged and then processed in the usual way.
#           If the template contains a _Template_Code atribute, it is
#           executed on the merged snippet before processing it.
#           Templates are defined in modules/20templates.pl.
#     SkipLink => if true, a "Skip this comic" link is generated before
#           the image, that redirects to right after it. Useful for
#           very long comics.
#
# Precedence (from higher to lower) is Function, StaticURL, StaticHTML,
# StartRegex/EndRegex and Regex.
sub get_comic {
  my $C=shift;
  my %C=%{$C};

  my $title=$C{Title};
  #$title="" if $C{NoShowTitle};
  $title = "nt|" . $title if $C{NoShowTitle};

  # Now see which method is specified for fetching the comic.
  if (defined($C{Function})) {
    return $C{Function}->($C);
  } elsif (defined($C{StaticURL})) {
    #return (qq(<img border=0 src="$C{StaticURL}">), $title, undef);
    return (qq(<img src="$C{StaticURL}" alt="Today's $C{Title} comic">), $title, undef);
  } elsif (defined($C{StaticHTML})) {
    return ($C{StaticHTML}, )
  } elsif (defined($C{Page})) {
    # Some sanity checks first...
    # If any of Start/EndRegex is defined, the other must also be
    if ( !$C{StartRegex} && $C{EndRegex} ) {
      return (undef, $C{Title}, "Internal Error: The comic definition has EndRegex but no StartRegex.\n");
    }
    my $startend = defined($C{StartRegex});
    # otherwise we expect a Regex attribute
    if (!$startend && !defined($C{Regex}) && !defined($C{LinkRelImageSrc})) {
      return (undef, $C{Title}, "Internal Error: The comic definition has a Page attribute but no Regex or LinkRelImageSrc attribute.\n");
    }
    # but we cannot have both Regex and Start/EndRegex
    if ( ($startend && $C{LinkRelImageSrc}) || (defined($C{Regex}) && $C{LinkRelImageSrc})) {
      return (undef, $C{Title}, "Internal Error: The comic definition can have only one of Regex/Start/EndRegex or LinkRelImageSrc attributes.\n");
    }
    if ($C{LinkRelImageSrc}) {
      $C{Regex} = qr(link rel=\"image_src\".* href=\"(http://.+?)\")i;
    }

    # Finally, we get to fetching the page
    fetch_url($C{Page},undef,undef,$C{RedirectMatch}, $C{RedirectURLCapture}, $C{RedirectURLPrepend}, $C{RedirectURLAppend}, $C{MultipleRedirects})
      or return (undef, $C{Title}, $err || "Error fetching page");
    my $output="";
    my @out=();
    my $incapture=0;
    while (get_line()) {
      unless($notitles) {
        if ($C{TitleRegex} && /$C{TitleRegex}/) {
          $title.=" - $1" if $1;
        }
      }
      if ($C{Regex} && /$C{Regex}/) {
        # Skip if StartRegex was also specified and we are not in the "capture" zone
        next if $startend && !$incapture;

        my $url=$1;
        return (undef, $C{Title},
                "Regular expression $C{Regex} matches, but did not return a match group")
          unless $url;
        $url = _do_regex_replacements($url, $C);
        $url.=$C{Append} if $C{Append};
        $url=$C{Prepend}.$url if $C{Prepend};
        $extraattrs=qq(alt="Today's $C{Title} comic");
        if (exists($C{ExtraImgAttrsRegex}) && /$C{ExtraImgAttrsRegex}/) {
          $tmp = $1;
          if ($tmp !~ m/alt=/i) {
            $extraattrs="$extraattrs $tmp";
          } else {
            $extraattrs = $tmp;
          }
        }
        if ($C{MultipleMatches}) {
          push @out, $url;
        } else {
          return (qq(<img src="$url" $extraattrs>), $title, undef);
        }
      } elsif ($C{StartRegex} && /$C{StartRegex}/) {
        $output.=$_ if $C{InclusiveCapture};
        $incapture=1;
      } elsif ($incapture && defined($C{EndRegex}) && /$C{EndRegex}/) {
        $output.=$_ if $C{InclusiveCapture};
        $incapture = 0;
        if (!$C{Regex}) {
          $output = _do_regex_replacements($output, $C);
          $output.=$C{Append} if $C{Append};
          $output=$C{Prepend}.$output if $C{Prepend};
          return ($output, $title, undef);
        }
      } elsif ($incapture) {
        $output.=$_;
      }
    }
    # Return the captured area if we captured until the end of the page
    # AND Regex was not defined (if it was, this means it never matched,
    # so we fall through to return an error below)
    if ($incapture && !defined($C{Regex})) {
      $output = _do_regex_replacements($output, $C);
      $output.=$C{Append} if $C{Append};
      $output=$C{Prepend}.$output if $C{Prepend};
      return ($output, $title, undef);
    }
    if ($C{MultipleMatches} && @out) {
      return (join("",@out), $title, undef);
    }
    return (undef, $C{Title}, "Could not find image in $C{Title}'s page");
  }
}

# Report and store errors
sub error {
  my $errstr=shift;
  warn $errstr;
  $allerrors.=$errstr;
}
