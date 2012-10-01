$COMIC{multiverse} = {
		   Title => 'Scenes From A Multiverse',
		   Page => 'http://amultiverse.com/',
		   Regex => qr!class="comicpane".*img\s+src\s*=\s*\"(.*/comics/.*?)"!i,
                   ExtraImgAttrsRegex => qr!img[^<>]*src="[^<>]*/comics/[^<>]*?" ((alt=".*?")\s*(title=".*"))!i,
                   #TitleRegex => qr!class="comicpane".*title="(.*?)"!i,
                   #ExtraImgAttrs => qr!class="comicpane".*(alt=".*?")!i,
		  };
