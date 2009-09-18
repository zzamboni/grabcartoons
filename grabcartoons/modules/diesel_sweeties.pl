$COMIC{diesel_sweeties}={
			 Title	=> 'Diesel Sweeties',
			 Page	=> 'http://www.dieselsweeties.com/',
			 Regex	=> qr(<img src="(\/(h)?strips\/.*?\d+.(png|gif))" border="0" alt="newest[^"]*")i,
			 Prepend => '{Page}',
			};

