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
$OUTPUTCSS
    -->
    </style>

    <!-- script to display title tag fields on mobile devices -->
    <script type="text/javascript">
$OUTPUTJS
    </script>


  </head>

  <body>
  <div id="header">
    <h1>Daily Comics - $today</h1>
  </div><!-- header -->

EOF
}

sub print_footer {
  print <<EOF;

<div id="footer">
<address>This page was created by <a href="http://zzamboni.org/grabcartoons/">grabcartoons $VERSION</a>.</address>
</div><!-- footer -->
  </body>
</html>
EOF
}

sub print_section {
  my ($name, $url, $html, $mainurl, $err, $skiplink)=@_;
  my $cname = $name;
  $cname =~ s/\W/_/g;
  # Fix URLs for ampersands
  $mainurl =~ s/&(?!amp;)/&amp;/gi if $mainurl;
      $url =~ s/&(?!amp;)/&amp;/gi if $url;
#     $html =~ s/&(?!amp;)/&amp;/gi if $html;
  # handle non-displaying titles
  my $style="";
  if ($name =~ /^nt\|(.*)/) {
    $name = $1;
    $style = " style=\"display:none;\"";
  }
  print "<div class=\"comicdiv\" id=\"div_$cname\">\n";
  print "<h2$style>$name</h2>\n\n";
  print "<h3><a href=\"#\" class=\"divtoggle\">Click to expand</a></h3>\n";
  print "<p>\n";
  if ($err) {
    print "<em>$err</em>\n\n";
  }
  else {
    $mainurl=$url if !$mainurl;
    print qq(<a href="#skip_$cname">Skip this comic.</a><br>\n) if $skiplink;
    if ($html) {
      print "<a href=\"$mainurl\">$html</a>\n";
    }
    else {
      print "<a href=\"$mainurl\"><img src=\"$url\" alt=\"Today's $name cartoon\"></a>\n";
    }
    print qq(<br><a name="skip_$cname"> </a>) if $skiplink;
  }
  print "</p>\n";
  print "</div><!-- div_$cname -->\n\n";
}

1;
