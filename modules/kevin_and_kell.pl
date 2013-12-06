$COMIC{kevin_and_kell} = {
			  Title => 'Kevin and Kell',
			  Page => 'http://www.kevinandkell.com',
			  Regex => qr!SRC\s*=\s*"((?:http://www.kevinandkell.com/)?.*?/strips/.*?\.(?:gif|png|jpg|jpeg))"!i,
			  Prepend => '{Page}',
			 };
