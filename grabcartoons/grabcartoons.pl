#!/p/perl/bin/perl
#
# Grab daily cartoons from their web sites.
# Diego Zamboni, Oct 28, 1998.
#
# $Id$

# This program generates many bogus warnings if run with -w enabled.
# The warnings are harmless but annoying, that's why I removed -w
# from the first line above.

use FindBin;
use Env qw(HOME GRABCARTOONS_DIRS);

@GRABCARTOONS_DIRS=split(/:/, $GRABCARTOONS_DIRS);

######################################################################
# Configuration section

# Where wget is located (leave as is if it's in your PATH)
# If you run it from crontab, make sure you set the PATH in the crontab
# entry, or provide the full path here.
$WGET_PATH="wget";

# Command to get a web page and print it to stdout
$WGET="$WGET_PATH -q -O-";

# Where to load cartoon modules from
@MODULE_DIRS=("$FindBin::RealBin/modules",
	      "$FindBin::Bin/../lib/grabcartoons/modules",
	      "$HOME/.grabcartoons",
	      @GRABCARTOONS_DIRS,
	     );

# End config section
######################################################################

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

# List defined modules
if ($ARGV[0] =~ /^(-l|--list)$/) {
  print "Modules defined:\n\t".join("\n\t", sort @list_of_modules)."\n";
  exit;
}
# Generate all cartoons
if ($ARGV[0] =~ /^(-a|--all)$/) {
  @ARGV=sort @list_of_modules;
}

&print_header;

foreach $name (@ARGV) {
  $page=lc($name);
  $page=~s/\W+/_/g;
  undef($err);
  $title=undef;
  ($url, $mainurl, $title)=eval "&get_url_$page()";
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

&print_footer;

sub print_header {
  my $today=scalar localtime;
  print <<EOF;
<html>
  <head>
    <title>Daily Comics - $today</title>
  </head>

  <body bgcolor="white" text="black">
    <h1>Daily Comics - $today</h1>
EOF
}

sub print_footer {
  print <<EOF;

<hr>
<small>This page was created automatically by grabcartoons, written by <a href="mailto:zamboni\@cs.purdue.edu">Diego Zamboni</a></small>
  </body>
</html>
EOF
}

sub print_section {
  my ($name, $url, $mainurl, $err)=@_;
  print "<hr>\n<h2>$name</h2>\n\n";
  if ($err) {
    print "<em>$err</em><p>\n\n";
  }
  else {
    $mainurl=$url if !$mainurl;
    print "<a href=\"$mainurl\"><img src=\"$url\" alt=\"Today's $name cartoon\" border=0></a><p>\n\n";
  }
}

######################################################################
# Cartoon URL generation section
# Each subroutine must return a two-element array containing the URL
# for the image of today's cartoon and the URL for the main page of
# the strip, or undef if an error occurs.
# Each subroutine must be named get_url_name, where "name" is the name
# of the cartoon, all in lowercase.
######################################################################
