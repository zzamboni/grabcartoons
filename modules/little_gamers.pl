$COMIC{little_gamers} = {
			 Title => 'Little Gamers',
			 Page => 'http://www.little-gamers.com/',
			 Regex => qr/img[^>]*id="comic"[^>]*src="(http(?:s)?:\/\/((?:pimp|www|upload)\.)?little-gamers.(com|eoo.se)\/comics\/[^"]*.(?:gif|jpg|jpeg|png))"/i,
                         'ExtraImgAttrsRegex' => qr!(title="[^"]*")!,
			 Prepend => '',
			};
