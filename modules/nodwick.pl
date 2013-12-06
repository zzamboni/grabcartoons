$COMIC{nodwick} = {
    Title => 'Nodwick',
    Page => 'http://comic.nodwick.com/',
    Regex => qr!img src="(?:http://comic.nodwick.com/)(wp-content/uploads/\d{4}/\d+/\d{4}-\d+-\d+.(?:jpg|jpeg|gif|png))"!i,
    Prepend => '{Page}/',
};
