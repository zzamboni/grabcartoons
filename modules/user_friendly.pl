$COMIC{user_friendly} = {
			 Title => 'User Friendly',
			 Base => 'http://www.userfriendly.org',
			 Page => '{Base}/static/',
			 Regex => qr/Latest.*SRC\s*=\s*"(.*\/cartoons\/.*?\.gif)"/i,
			};
