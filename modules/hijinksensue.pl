$COMIC{hijinksensue} = {
		   Title => 'Hijinks Ensue',
		   Page => 'http://hijinksensue.com/',
                   StartRegex => '<div id="comic">',
		   Regex => qr!img\s+src\s*=\s*\"(.*?(?:gif|png|jpg))"!i,
                   ExtraImgAttrsRegex => qr!(alt=".*?")!i,
		  };
