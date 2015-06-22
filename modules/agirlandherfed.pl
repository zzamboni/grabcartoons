$COMIC{agirlandherfed} = {
		Title => 'A Girl And Her Fed',
		Base => 'http://agirlandherfed.com/',
                Page => '{Base}',
                StartRegex => '<div id="comic-image">',
                EndRegex => qr(\</div\>),
                SubstOnRegexResult => [ [ qr(src="img/), 'src="{Base}img/', 1 ], [ qr((height|width)=.*), '', 1 ] ],
                ExtraImgAttrsRegex => qr!(title=".*?")!i,
	       };
