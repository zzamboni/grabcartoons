# Templates for comics.com strips, in both large and small formats.

$TEMPLATE{'comics.com_big'} = {
    'Base' => 'http://comics.com',
    'Page' => '{Base}/{Tag}/',
    'Regex' => qr(a href="(http://assets\.comics\.com/dyn/str_strip/.*?\.zoom\.(gif|png|jpg))"),
    '_Template_Code' => sub { $H=shift; unless ($H->{Tag}) { my $tag=lc($H->{Title}); $tag=~s/\s/_/g; $H->{Tag} = $tag } },
};

$TEMPLATE{'comics.com_small'} = {
    'Base' => 'http://comics.com',
    'Page' => '{Base}/{Tag}/',
    'Regex' => qr(img src="(http://assets\.comics\.com/dyn/str_strip/.*?\.full\.(gif|png|jpg))"),
    '_Template_Code' => sub { $H=shift; unless ($H->{Tag}) { my $tag=lc($H->{Title}); $tag=~s/\s/_/g; $H->{Tag} = $tag } },
};

$TEMPLATE{'gocomics.com'} = {
    'Base' => 'http://www.gocomics.com/',
    'Page' => '{Base}/{Tag}/',
    'Regex' => qr(src=\"(http://.*\.uclick\.com/comics/.*\.(jpg|gif|png)))i,
    '_Template_Code' => sub { $H=shift; unless ($H->{Tag}) { my $tag=lc($H->{Title}); $tag=~s/\s//g; $H->{Tag} = $tag } },
}