$COMIC{diesel_sweeties}={
			 Title	=> 'Diesel Sweeties',
			 Page	=> 'http://www.dieselsweeties.com/',
			 Regex	=> qr(<img src="((?:\/(h)?strips\/.*?)?(?:\d+|newest)\.(?:png|gif|jpg|jpeg))"[^>]*alt="newest[^"]*")i,
			 Prepend => '{Page}',
			};

