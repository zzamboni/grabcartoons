$COMIC{little_gamers} = {
			 Title => 'Little Gamers',
			 Page => 'http://www.little-gamers.com/',
			 Regex => qr/img src="(http:\/\/(pimp|www|upload).little-gamers.(com|eoo.se)\/comics\/\d+(-\d+)*.(gif|jpg))" alt=".*"/i,
                         'ExtraImgAttrsRegex' => qr!img src="[^"]*/comics/\d+[^"]*" alt="[^"]*" (title="[^"]*")!,
			 Prepend => '',
			};
