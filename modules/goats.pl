$COMIC{goats} = {
		 Title => 'Goats',
		 Page => 'http://www.goats.com',
		 Regex => qr/IMG SRC="(.*\/comix\/.*\.(gif|png|jpg))" WIDTH=(")?\d+(")? HEIGHT=(")?\d+(")?/i,
		 Prepend => '{Page}'
		};
