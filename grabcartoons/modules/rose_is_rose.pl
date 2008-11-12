$COMIC{rose_is_rose} = {
			Title => 'Rose is Rose',
			Base => 'http://comics.com',
			Page => '{Base}/rose_is_rose/',
			Regex => qr/src\s*=\s*"(.*?dyn\/str_strip\/.*?\.full\.(gif|jpg))"/i,
                        #Prepend => '{Base}',
		       };
