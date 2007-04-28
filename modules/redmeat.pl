$COMIC{redmeat} = {
		   Title => 'Red Meat',
		   Page => 'http://www.redmeat.com/redmeat/current/',
		   Regex => qr/img src="(.*\.gif)" width="\d\d\d" height="\d\d\d" alt="" border="0"/,
		   Prepend => '{Page}',
		   'NoShowTitle' => 1,
		  };
