#!/usr/bin/perl
#
# Try to semi-automate the conversion of modules from the old
# to the new format.
# Works with modules of the following structure:
# sub get_url_NAME {
#    ...BASE="baseurl";
#    ...PAGE="pageurl";
#    ...TITLE="ComicTitle";
#  ...
#  if (REGEX) {
#      return ("PREPEND$1", ...)
#  }
# }
# And produce a comic def using the components shown in uppercase.
#
# THE OUTPUT WILL MOST LIKELY NEED SOME TWEAKING!!!

use Data::Dumper;

while (<>) {
  next if /^\s+#/;
  $name=$1 if /get_url_(\S+)\s*\{/;
  if (/\$(.*base)\s*=\s*"(.*)";/) { $COMIC{Base}=$2; $var{Base}=$1; }
  if (/\$(.*page)\s*=\s*"(.*)";/) { $COMIC{Page}=$2; $var{Page}=$1; }
  if (/\$(.*title)\s*=\s*"(.*)";/) { $COMIC{Title}=$2; $var{Title}=$1; }
  if (/if \(m?(.*)\)\s*\{/) { $COMIC{Regex}="qr$1"; }
  if (/return\s*\(\s*"(.*)\$1",/) { $COMIC{Prepend}=$1; }
  if (/return\s*\(\s*(.+)\."?\$1"?,/) { $COMIC{Prepend}=$1; }
}

foreach $v (keys %COMIC) {
  foreach $j (keys %COMIC) {
    next unless $var{$j};
    $COMIC{$v} =~ s/\$$var{$j}/{$j}/g;
  }
}

print "\$COMIC{$name} = {\n";
foreach $k (qw(Title Base Page Regex Prepend)) {
  $q="'";
  $q='' if $k eq 'Regex';
  print "\t$k => $q$COMIC{$k}$q,\n" if $COMIC{$k};
}
print "\t};\n";
