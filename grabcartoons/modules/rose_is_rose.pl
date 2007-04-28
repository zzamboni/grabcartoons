$COMIC{rose_is_rose} = {
			Title => 'Rose is Rose',
			Base => 'http://www.unitedmedia.com',
			Page => '{Base}/comics/roseisrose/',
			Regex => qr/SRC\s*=\s*"(.*?images\/roseisrose.*?\.(gif|jpg))".*Today's Comic/i,
			Prepend => '{Base}',
		       };
