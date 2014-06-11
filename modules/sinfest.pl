$COMIC{sinfest} = {
		   Title => 'Sinfest',
		   Page => 'http://sinfest.net/',
		   Regex => qr!SRC\s*=\s*\".*?(\w+/comics/\d{4}-\d{2}-\d{2}\.(gif|jpg|png))!i,
		   Prepend => '{Page}',
		  };
