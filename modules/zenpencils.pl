$COMIC{zenpencils} = {
		   Title => 'Zen Pencils',
		   Page => 'http://zenpencils.com/',
		   Regex => qr!class="comicpane".*img\s+src\s*=\s*\"(.*/comics/.*?)"!i,
                   TitleRegex => qr!class="comicpane".*title="(.*?)"!i,
		  };
