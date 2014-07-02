$COMIC{redmeat} = {
		   Title => 'Red Meat',
		   Page => 'http://www.redmeat.com/max-cannon/FreshMeat',
		   Regex => qr/img src="(.*\.(?:gif|jpg|jpeg|png))" width="\d\d\d" height="\d\d\d"/,
		   ExtraImgAttrsRegex => qr/img src=".*\.(?:gif|jpg|jpeg|png)" width="\d\d\d" height="\d\d\d" (alt=".*?")/,
                   #Prepend => '{Page}',
		   'NoShowTitle' => 1,
		  };
