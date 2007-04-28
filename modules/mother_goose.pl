$COMIC{mother_goose} = {
			Title => 'Mother Goose & Grimm',
			Base => 'http://www.grimmy.com',
			Page => '{Base}/comics.php',
			Regex => qr!src="(http://www\.grimmy\.com/images/MGG_Archive/.*?\.gif)!i,
		       };
