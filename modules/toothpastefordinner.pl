$COMIC{toothpastefordinner} = {
    Title => 'Toothpaste for Dinner',
    Page => 'http://www.toothpastefordinner.com/',
    Regex => qr(\<h4\>.*img src="(.*?)")i,
    TitleRegex => qr(\<title\>Toothpaste For Dinner by \@drewtoothpaste - (.*?)\</title\>)i,
};
