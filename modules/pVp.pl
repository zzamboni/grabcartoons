$COMIC{pvp} = {
	       Title => 'pVp',
	       Base => 'http://www.pvponline.com/',
               Page => '{Base}comic',
               Regex => qr!src="(.*/img/comic/pvp\d+\.jpg)"!,
               TitleRegex => qr!<h2 id="headingArchive">(.*)</h2>!i,
	      };
