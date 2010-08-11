$COMIC{pvp} = {
	       Title => 'pVp',
	       Page => 'http://www.pvponline.com/',
               #Regex => qr!src=['"]({Page}comics/pvp\d+\.gif)['"]!,
               StartRegex => qr(\<div id="comic"\>),
               EndRegex => qr(\</div\>),
               #TitleRegex => qr!src=['"]{Page}comics/pvp\d+\.gif['"].*title="(.*)"!,
	      };
