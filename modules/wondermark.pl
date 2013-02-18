$COMIC{wondermark} = {
		      Title => 'Wondermark',
		      Page => 'http://wondermark.com/',
		      Regex => qr!src=".*/(c/.*\.(?:gif|png|jpg|jpeg))"!i,
		      Prepend => '{Page}',
		      ExtraImgAttrsRegex => qr!src=".*/c/.*\.(?:gif|png|jpg|jpeg)".*(alt=.*title=".*?")!i,
                      TitleRegex => qr!alt=.*title="(.*)"!i,
		      NoShowTitle => 1,
		     };

