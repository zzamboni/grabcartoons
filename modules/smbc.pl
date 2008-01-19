$COMIC{smbc} = {
		Title => 'Saturday Morning Breakfast Cereal',
		Page => 'http://www.smbc-comics.com/',
		Regex => qr!src="/(comics/.*.gif)"!i,
		Prepend => '{Page}',
	       };
