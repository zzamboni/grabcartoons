eval 'exec perl -x $0 ${1+"$@"}' # -*-perl-*-
  if 0;
#!perl -w
#
# Grab daily cartoons from their web sites.
# Diego Zamboni, Oct 28, 1998.
#

use FindBin;
use Getopt::Long;

use Env qw(HOME GRABCARTOONS_DIRS);

$VERSION="2.4";

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
$USER_AGENT=""; # uncomment the following line if you have problems
#$USER_AGENT=" -U \"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/521.25 (KHTML, like Gecko) Safari/521.24\"";
# TODO - add in other user-agent strings if needed
$XTRN_CMD="$XTRN_PROG -q -O- $USER_AGENT";

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

# End config section
######################################################################

$versiontext="GrabCartoons version $VERSION";
$usage="$versiontext
Usage: $0 [ options ] [ comic_id ...]
    --all      or -a   generate a page with all the known comics on stdout.
    --list     or -l   produce a list of the known comic_id's on stdout.
    --htmllist         produce HTML list of known comic_id's on stdout.
    --file     or -f   read list of comics from specified file.
    --random n         select n comics at random (they will be output after
                       any other comics requested)
    --write    or -w   write output to specified file instead of stdout.
    --version  or -V   print version number
    --verbose  or -v   be verbose
    --help     or -h   print this message.
    --notitles or -t   do not show comic titles (for those that have them)
    --templates        produce a list of defined templates

By default, it will produce a page with the given comics on stdout.

comic_id can be:
  - Any of the predefined modules (e.g. sinfest, adam_at_home)
  - Of the form 'template:comic title', including quotes if the title has
    spaces (e.g. 'gocomis.com:Citizen Dog', comics.com_big:Frazz). This will
    generate on the fly a module for the given comic.
";
$doall=0;
$dolist=0;
$listoftemplates=0;
$file=undef;
$output=undef;
$notitles=0;
$random=0;
$allerrors="";

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
        }
        else {
            die "Error: I couldn't find LWP::UserAgent nor $XTRN_PROG\n";
        }
    }
    else {
        $GET_METHOD=2;
        vmsg("Found LWP::UserAgent.\n");
    }
}
elsif ($GET_METHOD == 2) {
    vmsg("Loading LWP::UserAgent...\n");
    eval 'use LWP::UserAgent';
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

$lom="Comic IDs defined:\n\t".join("\n\t", sort @list_of_modules)."\n";
$htmlhdr="";

if ($dolist) {
  print $lom;
  exit;
}
if ($listoftemplates) {
  print "Templates defined:\n\t".join("\n\t", map { $_ . "\t" . $TEMPLATE{$_}->{_Template_Description}||"" } sort @list_of_templates)."\n";
  exit;
}

if ($htmllist) {
    # List defined modules, but in HTML
    @ARGV=sort @list_of_modules;
}

if ($doall) {
    # Generate all cartoons
    @ARGV=sort @list_of_modules;
}

# Read the comics from a file if desired
if( $file )
{
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
  if ($comic =~ /^.+:.+$/) {
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
  }
  else {
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
if( $output )
{
    open STDOUT, ">$output" or die "can't write to file $output: $!\n";
}


if ($htmllist) {
    &print_header_htmllist($htmlhdr);
}
else {
    &print_header;
}

# Finally, get the comics
vmsg("Getting cartoons...\n");
foreach $name (@ARGV) {
  my ($templ, $comic)=split(/:/, $name, 2);
  # If the given name is of the form template:cartoon and the template
  # is valid, generate a $COMIC snippet on the fly
  if ($templ && $comic) {
    if (defined($TEMPLATE{$templ})) {
      vmsg("  Generating module for '$comic' on the fly, using template '$templ'\n");
      $C={};
      $C->{Title} = $comic;
      $C->{Template} = $templ;
    }
    else {
      error("[$name] Error: I do not know template '$templ'\n");
      next;
    }
  }
  else {
    vmsg("  Getting $name.\n");
    if (!exists($COMIC{$name})) {
      error("[$name] Error: I do not know '$name'\n");
      next;
    }
    $C=$COMIC{$name};
  }

  undef($err);
  $title=undef;

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
      my $res=$TEMPLATE{$C->{Template}}->{_Init_Code}->($TEMPLATE{$C->{Template}}, $C);
      delete($TEMPLATE{$C->{Template}}->{_Init_Code}) if $res;
    }
    # Next, merge the fields of the comic's hash with the template hash
    my %tmpl=%{$TEMPLATE{$C->{Template}}};
    my ($k,$v);
    my $newC={};
    while (($k,$v) = each(%tmpl)) {
      $newC->{$k}=$v;
    }
    while (($k,$v) = each(%$C)) {
      $newC->{$k}=$v;
    }
    # If _Template_Code exists, execute it with the merged snippet as argument,
    # and delete it from the merged snippet
    if ($tmpl{_Template_Code}) {
      delete($newC->{_Template_Code});
      $tmpl{_Template_Code}->($newC);
    }
    # Replace $C with the merged snippet
    $C=$newC;
  }

  # replace variable references
  for (keys(%$C)) {
    $C->{$_}=_replace_vars($C->{$_}, $C);
  }
  $mainurl=$C->{Page};
  if ($htmllist) {
      &print_section_htmllist($name, $C->{Title}||$name, $mainurl);
      next;
  }
  ($html, $title, $err)=get_comic($C);
  if ($err || !$html) {
    if ($mainurl) {
      error("[$name] Error fetching $name [$mainurl]: $err\n");
      $err="Error fetching <a href=\"$mainurl\">$name</a>: $err";
    }
    else {
      $err="Error getting the URL for $name: $err";
      error("[$name] $err\n");
    }
  }
  &print_section($title, undef, $html, $mainurl, $err);
}

if ($htmllist) {
    &print_footer_htmllist;
}
else {
    &print_footer;
}

# Print any errors
if ($allerrors) {
    warn "The following errors occurred:\n$allerrors";
}

# Get a URL, split in lines and store them for later fetching.
# If an error occurs, returns undef.
sub fetch_url {
    my $url=shift;
    # If we are just producing a list of URLs, give a bogus error
    return undef if $htmllist;
    vmsg("    Fetching $url... ");
    if ($GET_METHOD == 2) {
        my $ua=LWP::UserAgent->new;
        my $req=new HTTP::Request('GET',$url);
        my $resp=$ua->request($req);
        if ($resp->is_error) {
            $err="Could not retrieve $url";
	    error("$err\n");
            return undef;
        }
        my $html=$resp->content;
        # Split on lines and store
        @LINES=split("\n", $html);
        $_.="\n" foreach (@LINES);
    }
    elsif ($GET_METHOD == 1) {
        my $cmd="$XTRN_CMD '$url'";
        open CMD, "$cmd |" or do {
            $err="Error executing '$cmd': $!";
	    error("$err\n");
            return undef;
        };
        @LINES=<CMD>;
        close CMD;
    }
    else {
        $err="Internal error: Invalid value of GET_METHOD ($GET_METHOD)";
	error("$err\n");
        return undef;
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

# Process a %COMIC snippet, passed as a hashref
# Return ($html, $title, $error)
# Valid fields:
#     Title   => title of the comic
#     Page    => URL where to get it
#     Regex   => regex to obtain image, must put the image in $1
#                   (the first parenthesized group)
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
#            These two field must always be included together.
#     InclusiveCapture => true/false value that specifies whether the lines
#            that match Start/EndRegex should be returned in the output. By
#            default InclusiveCapture == false.
#     StaticURL => static image URL to return
#     StaticHTML => static HTML snippet to return
#     Function  => a function to call. It must return
#           ($html, $title, $error)
#     NoShowTitle => if true, do not display the title of the comic
#           (for those that always have it in the drawing)
#     Template => if present, specified a template that will be used
#           for this comic (e.g. for comics coming from a single
#           sindicated site, so the mechanism is the same for all of them)
#           Essentially the fields from the template and the $COMIC snippet
#           are merged and then processed in the usual way.
#           If the template contains a _Template_Code atribute, it is
#           executed on the merged snippet before processing it.
#           Templates are defined in modules/20templates.pl.
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
    return $C{Function}->();
  }
  elsif (defined($C{StaticURL})) {
    #return (qq(<img border=0 src="$C{StaticURL}">), $title, undef);
    return (qq(<img src="$C{StaticURL}" alt="Today's $C{Title} comic">), $title, undef);
  }
  elsif (defined($C{StaticHTML})) {
    return ($C{StaticHTML}, )
  }
  elsif (defined($C{Page})) {
    # Some sanity checks first...
    # If any of Start/EndRegex is defined, the other must also be
    if ( ($C{StartRegex} && !$C{EndRegex}) || (!$C{StartRegex} && $C{EndRegex}) ) {
      return (undef, $C{Title}, "Internal Error: The comic definition has one of Start/EndRegex but not the other.\n");
    }
    my $startend = defined($C{StartRegex});
    # otherwise we expect a Regex attribute
    if (!$startend && !defined($C{Regex})) {
      return (undef, $C{Title}, "Internal Error: The comic definition has a Page attribute but no Regex attribute.\n");
    }
    # but we cannot have both Regex and Start/EndRegex
    if ($startend && defined($C{Regex})) {
      return (undef, $C{Title}, "Internal Error: The comic definition has both Regex and Start/EndRegex attributes.\n");
    }

    # Finally, we get to fetching the page
    fetch_url($C{Page})
      or return (undef, $C{Title}, $err || "Error fetching page");
    my $output="";
    while (get_line()) {
      unless($notitles) {
	if ($C{TitleRegex} && /$C{TitleRegex}/) {
	  $title.=" - $1" if $1;
	}
      }
      if ($C{Regex} && /$C{Regex}/) {
	my $url=$1;
	return (undef, $C{Title}, 
		"Regular expression $C{Regex} matches, but did not return a match group")
	  unless $url;
	$url = _do_regex_replacements($url, $C);
	$url.=$C{Append} if $C{Append};
	$url=$C{Prepend}.$url if $C{Prepend};
	$extraattrs=qq(alt="Today's $C{Title} comic");
	if (exists($C{ExtraImgAttrsRegex}) && /$C{ExtraImgAttrsRegex}/) {
	    $extraattrs=$1 if $1;
	}
	#return (qq(<img border=0 src="$url">), $title, undef);
        return (qq(<img src="$url" $extraattrs>), $title, undef);
      }
      elsif ($C{StartRegex} && /$C{StartRegex}/) {
	$output.=$_ if $C{InclusiveCapture};
	$incapture=1;
      } elsif ($incapture && /$C{EndRegex}/) {
	$output.=$_ if $C{InclusiveCapture};
	$incapture = 0;
	$output = _do_regex_replacements($output, $C);
	$output.=$C{Append} if $C{Append};
	$output=$C{Prepend}.$output if $C{Prepend};
	return ($output, $title, undef);
      } elsif ($incapture) {
	$output.=$_;
      }
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
