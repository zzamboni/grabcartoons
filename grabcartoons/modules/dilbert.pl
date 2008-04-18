$COMIC{dilbert} = {
		   'Title' => 'Dilbert',
		   'Base' => 'http://feeds.feedburner.com',
		   'Page' => '{Base}/DilbertDailyStrip',
		   'Regex' => qr!SRC="(http://(www.)?dilbert.com/[^<>]*strip\.print\.(gif|jpg))[^<>]*"!i,
		   #'Prepend' => '{Base}',
                  };
