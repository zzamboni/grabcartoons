$COMIC{hijinksensue} = {
		   Title => 'Hijinks Ensue',
		   Page => 'http://hijinksensue.com/',
		   Regex => qr!class="comicpane".*img\s+src\s*=\s*\"(.*/comics/.*?)"!i,
                   TitleRegex => qr!class="comicpane".*title="(.*?)"!i,
                   ExtraImgAttrs => qr!class="comicpane".*(alt=".*?")!i,
		  };
