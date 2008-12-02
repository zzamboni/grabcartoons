$COMIC{wondermark} = {
		      Title => 'Wondermark',
		      Page => 'http://wondermark.com/',
		      Regex => qr!src="({Page}c/.*\.gif)"!i,
		      ExtraImgAttrsRegex => qr!src="{Page}c/.*\.gif".*(alt=.*title=".*?")!i,
		      NoShowTitle => 1,
		     };
