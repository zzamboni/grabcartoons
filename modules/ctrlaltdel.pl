$COMIC{ctrlaltdel} = {
		Title => 'Ctrl+Alt+Del',
		Base => 'http://www.ctrlaltdel-online.com/',
		Page => '{Base}comic.php',
		Regex => qr!img +src="(/comics.*?)"!i,
		Prepend => '{Base}',
	       };
