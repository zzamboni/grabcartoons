$COMIC{three_panel_soul} = {
			Title => 'Three Panel Soul',
			Page => 'http://threepanelsoul.com/',
			Regex => qr!src="(http://(?:www.)?threepanelsoul.com/comics/[-0-9]+.*\.(?:png|jpg|jpeg|gif))"!i,
                        ExtraImgAttrsRegex => qr!(alt=.*title=".*?")!i,
		       };
