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

    .caption { display: none; font-size:x-large; }
    \@media screen and (max-device-width: 480px) { img{width:100%;} p.caption { display:inline; } }
    \@media screen and (min-device-width: 768px) and (max-device-width: 1024px) { img{ width:100%;} p.caption { display:inline; } }

    -->
    </style>

    <!-- script to display title tag fields on mobile devices -->
    <script type="text/javascript">
        window.onload = showTitleText;
        function showTitleText() {
            var imgTags;
            imgTags = document.getElementsByTagName("img");
            for(var i = 0; i < imgTags.length; i++)
                if (imgTags[i].title != "")  {
                    var parent =  imgTags[i].parentNode.parentNode;
                    var newText = document.createElement('p');
                    newText.innerHTML = "<br>"+imgTags[i].title;
                    newText.style.backgroundColor="#ffffaa";
                    newText.style.color="#000000";
                    newText.className="caption";
                    newText.style.padding="3px";
                    parent.appendChild(newText);
                }  
        }
    </script>


  </head>

  <body>
    <h1>Daily Comics - $today</h1>
EOF
}

sub print_footer {
  print <<EOF;

<hr>
<address>This page was created by <a href="http://zzamboni.org/grabcartoons/">grabcartoons $VERSION</a>.</address>
  </body>
</html>
EOF
}

sub print_section {
  my ($name, $url, $html, $mainurl, $err)=@_;
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
