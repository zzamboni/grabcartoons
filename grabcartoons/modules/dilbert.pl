$COMIC{dilbert} = {
		   'Title' => 'Dilbert',
		   'Base' => 'http://www.unitedmedia.com',
		   'Page' => '{Base}/comics/dilbert/',
		   'Regex' => qr/SRC="([\w.\/]+\.(gif|jpg))[^<>]*ALT="today's( Dilbert)? comic/i,
		   'Prepend' => '{Base}',
                  };
