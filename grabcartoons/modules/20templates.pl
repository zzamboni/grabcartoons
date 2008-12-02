# Templates for comics.com strips, in both large and small formats.

$TEMPLATE{'comics.com_big'} = {
    'Base' => 'http://comics.com',
    'Page' => '{Base}/{_tag_}/',
    'Regex' => qr(a href="(http://assets\.comics\.com/dyn/str_strip/.*?\.zoom\.(gif|png|jpg))"),
    '_Template_Code' => sub { $H=shift; unless ($H->{_tag_}) { my $tag=lc($H->{Title}); $tag=~s/\s/_/g; $H->{_tag_} = $tag } },
};

$TEMPLATE{'comics.com_small'} = {
    'Base' => 'http://comics.com',
    'Page' => '{Base}/{_tag_}/',
    'Regex' => qr(img src="(http://assets\.comics\.com/dyn/str_strip/.*?\.full\.(gif|png|jpg))"),
    '_Template_Code' => sub { $H=shift; unless ($H->{_tag_}) { my $tag=lc($H->{Title}); $tag=~s/\s/_/g; $H->{_tag_} = $tag } },
};

