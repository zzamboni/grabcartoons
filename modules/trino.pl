# Comics by the mexican author Trino. Very infrequently updated,
# unfortunately.

sub get_url_cronicas_marcianas {
  my $trinobase="http://www.trino.com.mx";
  my $trinopage=$trinobase;
  return("$trinobase/cartones/cronicas.jpg", $trinopage, "Cronicas marcianas");
}

sub get_url_el_rey_chiquito {
  my $trinobase="http://www.trino.com.mx";
  my $trinopage=$trinobase;
  return("$trinobase/cartones/rey.gif", $trinopage, "El Rey Chiquito");
}

sub get_url_fabulas_de_policias_y_ladrones {
  my $trinobase="http://www.trino.com.mx";
  my $trinopage=$trinobase;
  return("$trinobase/cartones/fabulas.gif", $trinopage,
  	 "Fabulas de Policias y Ladrones");
}

sub get_url_don_taquero {
  my $trinobase="http://www.trino.com.mx";
  my $trinopage=$trinobase;
  return("$trinobase/cartones/taquero.gif", $trinopage, "Don Taquero");
}


1;
