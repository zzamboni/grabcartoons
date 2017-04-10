$COMIC{diesel_sweeties}={
			 Title	=> 'Diesel Sweeties',
			 Page	=> 'http://www.dieselsweeties.com/',
			 Regex	=> qr(<img class="xomic"[^>]*src="((?:\/(h)?strips.*?)[^>]*\.(?:png|gif|jpg|jpeg))")i,
			 Prepend => '{Page}',
			};

