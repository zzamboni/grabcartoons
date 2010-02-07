$COMIC{nedroid} = {
		Title => 'Nedroid',
		Page => 'http://www.nedroid.com/',
		Regex => qr!img[^<>]*src="(.*/comics/.*?\.(gif|jpg|png))"!i,
		ExtraImgAttrsRegex => qr!img[^<>]*src="[^<>]*/comics/[^<>]*?" (title=".*")!i,
            };
