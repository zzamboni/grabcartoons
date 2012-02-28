$COMIC{the_zombie_hunters} = {
		Title => 'The Zombie Hunters',
		Page => 'http://www.thezombiehunters.com/',
		Regex => qr!img[^<>]*src="(.*/strips/.*?\.jpg)"!i,
		TitleRegex => qr!comictitle">(.+)!i,
                Prepend => '{Page}',
	       };
