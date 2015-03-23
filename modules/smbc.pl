$COMIC{smbc} = {
		Title => 'Saturday Morning Breakfast Cereal',
		Page => 'http://www.smbc-comics.com/',
		Regex => qr!src=["'].*[/]?(comics/.*\d+.(?:gif|png|jpg|jpeg))["']!i,
                ExtraImgAttrsRegex => qr!(title=".*?")!i,
		Prepend => '{Page}',
	       };
