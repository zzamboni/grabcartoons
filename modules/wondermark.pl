$COMIC{wondermark} = {
		      Title => 'Wondermark',
		      Page => 'http://wondermark.com/',
		      Regex => qr!src=".*/(c/.*\.gif)"!i,
		      Prepend => '{Page}',
		      ExtraImgAttrsRegex => qr!src=".*/c/.*\.gif".*(alt=.*title=".*?")!i,
		      NoShowTitle => 1,
		     };
