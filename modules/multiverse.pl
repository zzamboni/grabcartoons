$COMIC{multiverse} = {
		   Title => 'Scenes From A Multiverse',
		   Page => 'http://amultiverse.com/',
                   #StartRegex => qr!<div id="comic">!i,
                   Regex => qr!<img\s+src="([^<>]*?)"\s+alt=".*?"\s+title=".*?"!i,
                   ExtraImgAttrsRegex => qr!img[^<>]*src="[^<>]*?" ((alt=".*?")\s*(title=".*"))!i,
                   #TitleRegex => qr!class="comicpane".*title="(.*?)"!i,
                   #ExtraImgAttrs => qr!class="comicpane".*(alt=".*?")!i,
		  };
