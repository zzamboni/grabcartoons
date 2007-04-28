$COMIC{diesel_sweeties}={
			 Title	=> 'Diesel Sweeties',
			 Page	=> 'http://www.dieselsweeties.com/',
			 Regex	=> qr(<img src="(\/hstrips\/.*\/\d+.(png|gif))" border="0" alt="newest cartoon")i,
			 Prepend => '{Page}',
			};

