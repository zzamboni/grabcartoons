$COMIC{eightbit} = {
			     Title => '8-Bit Theater',
			     Base => 'http://www.nuklearpower.com/',
			     Page => '{Base}8-bit-theater/',
			     Regex => qr(src="(http://www\.nuklearpower\.com/comics/8-bit-theater/\d+\.(gif|jpg|png))"),
			     TitleRegex => qr(\<div class="navbar-title"\>(.*?)\</div\>),
			    };
