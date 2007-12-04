$COMIC{megatokyo} = {
		     Title => 'MegaTokyo',
		     Page => 'http://www.megatokyo.com/',
		     Regex => qr!IMG[^>]*SRC="\/?(strips\/\d+\.(gif|jpg))"!i,
		     ExtraImgAttrsRegex => qr!IMG[^>]*SRC=[^>]*strips[^>]*(title="[^"]*")!i,
		     Prepend => '{Page}',
		    };
