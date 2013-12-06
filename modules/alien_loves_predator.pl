$COMIC{alien_loves_predator} = {
				'Title' => 'Alien Loves Predator',
				'StartRegex' => qr/div id="comic"/,
				'Regex' => qr!src="(.*?/strips/.*?)"!i,
				'Base' => 'http://alienlovespredator.com',
                                'Page' => '{Base}/',
                               };
