eval 'exec perl -x $0 ${1+"$@"}' # -*-perl-*-
  if 0;
#!perl
#
# Grab daily cartoons from their web sites.
# Diego Zamboni, Oct 28, 1998.
#
# $Id$

# This program generates many bogus warnings if run with -w enabled.
# Fixing them would probably be more trouble than it's worth, that's
# why there no -w above.

use FindBin;
use Getopt::Long;
use Env qw(HOME GRABCARTOONS_DIRS);

my $VERSION="1.1";

my @GRABCARTOONS_DIRS=split(/:/, $GRABCARTOONS_DIRS);

######################################################################
# Configuration section

# What to use: 0 - autoselect, 1 - external command, 2 - LWP::UserAgent
$GET_METHOD=0;

# Command to get a web page and print it to stdout, if $GET_METHOD=2
# or you don't have LWP::UserAgent installed
$XTRN_CMD="wget -q -O-";

# Where to load cartoon modules from
@MODULE_DIRS=("$FindBin::Bin/modules",
              "$FindBin::RealBin/modules",
	      "$FindBin::Bin/../lib/grabcartoons/modules",
	      "$FindBin::RealBin/../lib/grabcartoons/modules",
	      "$HOME/.grabcartoons",
	      @GRABCARTOONS_DIRS,
	     );

# End config section
######################################################################

# Check get method
if ($GET_METHOD == 0) {
    eval 'use LWP::UserAgent';
    if ($@) {
        if (system("$XTRN_CMD --help >/dev/null 2>/dev/null") == 0) {
            $GET_METHOD=1;
        }
    }
    else {
        $GET_METHOD=2;
    }
}
elsif ($GET_METHOD == 2) {
    eval 'use LWP::UserAgent';
}

# Eliminate duplicates in @MODULE_DIRS (in most cases Bin and RealBin
# will be the same)
my %mod_seen=();
@MODULE_DIRS = grep { ! $mod_seen{$_} ++ } @MODULE_DIRS;
# Load modules
foreach $mdir (@MODULE_DIRS) {
  if (-d $mdir) {
    opendir MDIR, $mdir
      or die "Error opening directory $mdir: $!\n";
    @mods=grep { /\.pl$/ && -f } map { "$mdir/$_" } readdir(MDIR);
    closedir MDIR;
    foreach (@mods) {
      require $_;
    }
  }
}

@list_of_modules=map { s/.*get_url_//; $_ } 
                     grep { /get_url_.*$/ } keys %main::;

$lom="Comic IDs defined:\n\t".join("\n\t", sort @list_of_modules)."\n";
$versiontext="GrabCartoons version $VERSION";
$usage="$versiontext
Usage: $0 [ option | comic_id ...]
--all     or -a   generate a page with all the known comics on stdout.
--list    or -l   produce a list of the known comic_id's on stdout.
--htmllist        produce HTML list of known comic_id's on stdout.
--version or -v   print version number
--help    or -h   print this message.
Otherwise, it will produce a page with the given comics on stdout.
";
$htmlhdr="";

# Process options
GetOptions(
           'all|a' =>
           sub {
               # Generate all cartoons
               @ARGV=sort @list_of_modules;
           },
           'list|l' =>
           sub {
               # List defined modules
               print $lom;
               exit;
           },
           'htmllist' =>
           sub {
               # List defined modules, but in HTML
               @ARGV=sort @list_of_modules;
               $htmllist=1;
           },
           'version|v' =>
           sub {
               # Version
               print "$versiontext\n";
               exit;
           },
           'help|h' =>
           sub {
               # Help
               print $usage;
               exit;
           },
          );

if (!@ARGV) {
    print $usage;
    exit;
}

if ($htmllist) {
    &print_header_htmllist($htmlhdr);
}
else {
    &print_header;
}

foreach $name (@ARGV) {
  $page=lc($name);
  $page=~s/\W+/_/g;
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
    }
    else {
      $err="Error getting the URL for $name ($page): $err";
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
    if ($GET_METHOD == 2) {
        my $ua=LWP::UserAgent->new;
        my $req=new HTTP::Request('GET',$url);
        my $resp=$ua->request($req);
        if ($resp->is_error) {
            $err="Could not retrieve $url";
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
            return undef;
        };
        @LINES=<CMD>;
        close CMD;
    }
    else {
        $err="Internal error: Invalid value of GET_METHOD ($GET_METHOD)";
        return undef;
    }
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
