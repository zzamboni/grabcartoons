$COMIC{megatokyo} = {
		     Title => 'MegaTokyo',
		     Page => 'http://www.megatokyo.com/',
		     Regex => qr!IMG[^>]*SRC="\/?(strips\/\d+\.(gif|jpg|png))"!i,
		     ExtraImgAttrsRegex => qr!IMG[^>]*SRC=[^>]*strips[^>]*(title="[^"]*")!i,
		     Prepend => '{Page}',
		    };
