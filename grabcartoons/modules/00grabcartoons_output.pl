# Output routines, here you can modify how the output page looks.

sub print_header {
  my $today=scalar localtime;
  print <<EOF;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
  
<html>
  <head>
    <title>Daily Comics</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <style type="text/css">
    <!--
      body { color: black; background-color: white; }
      a img { border-width: 0; }
      address { font-size: small; font-style: normal; }
    -->
    </style>
  </head>

  <body>
    <h1>Daily Comics - $today</h1>
EOF
}

sub print_footer {
  print <<EOF;

<hr>
<address>This page was created by <a href="http://grabcartoons.sourceforge.net/">grabcartoons $VERSION</a>.</address>
  </body>
</html>
EOF
}

sub print_section {
  my ($name, $url, $html, $mainurl, $err)=@_;
  # Fix URLs for ampersands
  $mainurl =~ s/&(?!amp;)/&amp;/gi if $mainurl;
      $url =~ s/&(?!amp;)/&amp;/gi if $url;
     $html =~ s/&(?!amp;)/&amp;/gi if $html;
  # handle non-displaying titles
  my $style="";
  if ($name =~ /^nt\|(.*)/) {
    $name = $1;
    $style = " style=\"display:none;\"";
  }
  print "<hr>\n<h2$style>$name</h2>\n\n";
  print "<p>\n";
  if ($err) {
    print "<em>$err</em>\n\n";
  }
  else {
    $mainurl=$url if !$mainurl;
    if ($html) {
      print "<a href=\"$mainurl\">$html</a>\n";
    }
    else {
      print "<a href=\"$mainurl\"><img src=\"$url\" alt=\"Today's $name cartoon\"></a>\n";
    }
  }
  print "</p>\n\n";
}

1;
