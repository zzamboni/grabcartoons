# These are the output subroutines used by the --html option. You should
# not normally modify them.

sub print_header_htmllist {
    my $hdr=shift||"";
    print "$hdr<ul>\n";
}

sub print_footer_htmllist {
    my $ftr=shift||"\n";
    print "</ul>$ftr";
}

sub print_section_htmllist {
    my ($id, $name, $url)=@_;
    print qq(  <li> <a href="$url">$name</a> ($id)\n);
}

1;
