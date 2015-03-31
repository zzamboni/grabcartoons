$COMIC{xkcd} = {
		Title => 'xkcd',
		Page => 'http://xkcd.com/',
		Regex => qr!img[^<>]*src="(?:http:)?//(imgs\.xkcd\.com/comics.*?)"!i,
                Prepend => 'http://', 
		TitleRegex => qr!^<div id="ctitle">(.+)</div>!i,
		ExtraImgAttrsRegex => qr!(title=".*")!i,
	       };
