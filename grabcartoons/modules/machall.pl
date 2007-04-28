$COMIC{machall} = {
		   Title => 'MacHall',
		   Page => 'http://www.machall.com/',
		   Regex => qr/img src='\/(index.php\?do_command=show_strip\&strip_id=\d+\&auth=\d+-\d+-\d+-\d+-\d+)'/,
		   Prepend => '{Page}',
		   'NoShowTitle' => 1,
		  };
