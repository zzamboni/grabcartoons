sub get_url_sinfest {
  my $sinfestbase="http://sinfest.net/";
  my $sinfestpage=$sinfestbase;
  my ($s,$m,$h,$dy,$mo,$yr)=localtime(time);
  return(sprintf("$sinfestbase/comics/sf%4d%02d%02d.gif", $yr+1900, $mo+1, $dy),
  	$sinfestpage, "Sinfest");
}


1;
