$COMIC{pvp} = {
	       Title => 'pVp',
	       Page => 'http://www.pvponline.com/',
	       Regex => qr!src=['"]({Page}comics/pvp\d+\.gif)['"]!,
	       TitleRegex => qr!src=['"]{Page}comics/pvp\d+\.gif['"].*title="(.*)"!,
	      };
