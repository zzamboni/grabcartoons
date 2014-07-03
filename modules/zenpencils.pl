$COMIC{zenpencils} = {
		   Title => 'Zen Pencils',
		   Page => 'http://zenpencils.com/',
                   StartRegex => '<div id="comic">',
		   Regex => qr!img\s+src\s*=\s*"(.*?(?:gif|png|jpg))"!i,
                   ExtraImgAttrsRegex => qr!(title=".*?")!i,
		  };
