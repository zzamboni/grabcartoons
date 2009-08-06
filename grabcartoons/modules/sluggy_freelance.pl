$COMIC{sluggy_freelance} = {
			    Title => 'Sluggy Freelance',
			    Page => 'http://www.sluggy.com/',
			    Regex => qr/SRC\s*=\s*"(.*\/comics\/.*?\.(gif|jpg))"/i,
                            Prepend => '{Page}',
			   };
