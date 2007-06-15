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

$VERSION="2.0";

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
    --all     or -a   generate a page with all the known comics on stdout.
    --list    or -l   produce a list of the known comic_id's on stdout.
    --htmllist        produce HTML list of known comic_id's on stdout.
    --file    or -f   read list of comics from specified file.
    --write   or -w   write output to specified file instead of stdout.
    --version or -V   print version number
    --verbose or -v   be verbose
    --help    or -h   print this message.

Otherwise, it will produce a page with the given comics on stdout.
";
$doall=0;
$dolist=0;
$file=undef;
$output=undef;

# Process options
GetOptions(
           'all|a'     => \$doall,
           'list|l'    => \$dolist,
           'htmllist'  => \$htmllist,
           'f|file=s'  => \$file,
           'w|write=s' => \$output,
           'verbose|v' => \$verbose,
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

$lom="Comic IDs defined:\n\t".join("\n\t", sort @list_of_modules)."\n";
$htmlhdr="";

if ($dolist) {
    print $lom;
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
    s/^\s+//g for @ARGV;
    s/\s+$//g for @ARGV;
    s/\s+/_/g for @ARGV;
    @ARGV = grep !/^#/, @ARGV;
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

vmsg("Getting cartoons...\n");
foreach $name (@ARGV) {
  $page=lc($name);
  $page=~s/\W+/_/g;
  vmsg("  Getting $page.\n");
  undef($err);
  $title=undef;
  if (!exists($COMIC{$page})) {
    warn "Error: I do not know '$page'\n";
    next;
  }
  $C=$COMIC{$page};
  # replace variable references
  for (keys(%$C)) {
    $C->{$_}=_replace_vars($C->{$_}, $C);
  }
  $mainurl=$C->{Page};
  if ($htmllist) {
      &print_section_htmllist($page, $C->{Title}||$name, $mainurl);
      next;
  }
  ($html, $title, $err)=get_comic($C);
  if ($err || !$html) {
    if ($mainurl) {
      $err="Error getting the URL for <a href=\"$mainurl\">$name</a> ($page): $err";
      vmsg("$err\n");
    }
    else {
      $err="Error getting the URL for $name ($page): $err";
      vmsg("$err\n");
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

# Get a URL, split in lines and store them for later fetching.
# If an error occurs, returns undef.
sub fetch_url {
    my $url=shift;
    # If we are just producing a list of URLs, give a bogus error
    return undef if $htmllist;
    vmsg("  Fetching $url... ");
    if ($GET_METHOD == 2) {
        my $ua=LWP::UserAgent->new;
        my $req=new HTTP::Request('GET',$url);
        my $resp=$ua->request($req);
        if ($resp->is_error) {
            $err="Could not retrieve $url";
            vmsg("$err\n");
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
            vmsg("$err\n");
            return undef;
        };
        @LINES=<CMD>;
        close CMD;
    }
    else {
        $err="Internal error: Invalid value of GET_METHOD ($GET_METHOD)";
        vmsg("$err\n");
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

# Replace references of the form $Name with the
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
#     Prepend/Append => strings to prepend or append to $1 before
#            returning it. May make use of other fields, referenced
#            as {FieldName}
#     StaticURL => static image URL to return
#     StaticHTML => static HTML snippet to return
#     Function  => a function to call. It must return
#           ($html, $title, $error)
#     NoShowTitle => if true, do not display the title of the comic
#           (for those that always have it in the drawing)
#
# Precedence (from higher to lower) is Function, StaticURL, StaticHTML,
# and Regex.
sub get_comic {
  my $C=shift;
  my %C=%{$C};
  my $title=$C{Title};
  #$title="" if $C{NoShowTitle};
  $title = "nt|" . $title if $C{NoShowTitle};

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
    unless (defined($C{Regex})) {
      return (undef, $C{Title}, "The comic definition has a Page attribute but no Regex attribute.\n");
    }
    fetch_url($C{Page})
      or return (undef, $C{Title}, $err || "Error fetching page");
    while (get_line()) {
      if (/$C{Regex}/) {
	my $url=$1;
	return (undef, $C{Title}, 
		"Regular expression $C{Regex} matches, but did not return a match group")
	  unless $url;
	$url.=$C{Append} if $C{Append};
	$url=$C{Prepend}.$url if $C{Prepend};
	$extraattrs=qq(alt="Today's $C{Title} comic");
	if (exists($C{ExtraImgAttrsRegex}) && /$C{ExtraImgAttrsRegex}/) {
	    $extraattrs=$1 if $1;
	}
	#return (qq(<img border=0 src="$url">), $title, undef);
        return (qq(<img src="$url" $extraattrs>), $title, undef);
      }
    }
    return (undef, $C{Title}, "Could not find image in $C{Title}'s page");
  }
}
