$COMIC{phd} = {
	       Title => 'Piled Higher and Deeper',
	       Base => 'http://www.phdcomics.com',
	       Page => 'http://www.phdcomics.com/comics.php',
	       Regex => qr/src=(?:http:\/\/www.phdcomic(?:s)?.com\/)?(comics\/archive\/[^.]+\.gif)/,
	       TitleRegex => qr!<title>PHD Comics:\s+(.+)</title>!i,
	       Prepend => '{Base}/',
	      };
