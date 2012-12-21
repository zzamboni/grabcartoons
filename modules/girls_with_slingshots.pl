$COMIC{girls_with_slingshots} = {
        Title => 'Girls with Slingshots',
        Page => 'http://www.girlswithslingshots.com/',
        Regex => qr!src="(http://cdn.*?/comics/.*?)"!i,
        ExtraImgAttrsRegex => qr/(title="[^"]*")/,
    };
