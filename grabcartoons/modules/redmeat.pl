$COMIC{redmeat} = {
		   Title => 'Red Meat',
		   Page => 'http://www.redmeat.com/redmeat/current/',
		   Regex => qr/img src="(.*\.gif)" width="\d\d\d" height="\d\d\d" border="0"/,
		   ExtraImgAttrsRegex => qr/img src=".*\.gif" width="\d\d\d" height="\d\d\d" border="0" (alt=".*?")/,
		   Prepend => '{Page}',
		   'NoShowTitle' => 1,
		  };
