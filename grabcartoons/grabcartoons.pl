eval 'exec perl -x $0 ${1+"$@"}' # -*-perl-*-
  if 0;
#!perl -w
#
# Grab daily cartoons from their web sites.
# Diego Zamboni, Oct 28, 1998.
#
# $Id$

use FindBin;
use Getopt::Long;

use Env qw(HOME GRABCARTOONS_DIRS);

$VERSION="1.9";

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
$XTRN_CMD="$XTRN_PROG -q -O-";

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

@list_of_modules=map { s/.*get_url_//; $_ } 
                     grep { /get_url_.*$/ } keys %main::;

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
  ($url, $mainurl, $title)=eval "&get_url_$page()";
  if ($htmllist) {
      &print_section_htmllist($page, $title||$name, $mainurl);
      next;
  }
  $err=$@ if $@;
  if ($err || !$url) {
    if ($mainurl) {
      $err="Error getting the URL for <a href=\"$mainurl\">$name</a> ($page): $err";
      vmsg("$err\n");
    }
    else {
      $err="Error getting the URL for $name ($page): $err";
      vmsg("$err\n");
    }
    undef $url;
  }
  &print_section($title||$name, $url, $mainurl, $err);
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
