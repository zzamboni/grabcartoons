$COMIC{partiallyclips} = {
			  Title => 'PartiallyClips',
			  Base => 'http://www.partiallyclips.com',
			  Page => '{Base}/index.php?b=1',
			  Regex => qr/IMG SRC="({Base}.*\/storage\/.*\.(gif|png|jpg))" border="0" Title="Click for larger version"/i,
			  'NoShowTitle' => 1,
			 };
