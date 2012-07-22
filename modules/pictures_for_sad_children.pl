$COMIC{pictures_for_sad_children} = {
		    'Title' => 'Pictures for Sad Children',
		    'Page' => 'http://www.picturesforsadchildren.com',
		    'Regex' => qr!class="photo-wrapper".*img src="(http://.*\.media\.tumblr\.com/[^"]*_[0-9]*.(?:png|gif|jpg))"!,
		    'ExtraImgAttrsRegex' => qr!class="photo-wrapper".*img src="http://.*\.media\.tumblr\.com/[^"]*_[0-9]*.(?:png|gif|jpg)" (title="[^"]*")!,
                    #'Regex' => qr!img src="(http://www\.picturesforsadchildren\.com/comics/[^"]*)"!,
                    #'ExtraImgAttrsRegex' => qr!img src="http://www\.picturesforsadchildren\.com/comics/[^"]*" (title="[^"]*")!,
		    'NoShowTitle' => 0,
                   };
