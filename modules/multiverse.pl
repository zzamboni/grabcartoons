$COMIC{multiverse} = {
		   Title => 'Scenes From A Multiverse',
		   Page => 'http://amultiverse.com/',
                   StartRegex => qr!<div id="comic">!i,
                   EndRegex => qr!</div>!i,
                   InclusiveCapture => True,
                   SubstOnRegexResult => [
                       [ qr!\s*<div id="comic">\s*!, '' ],
                       [ qr((\R)+), '', 1 ],
                       [ qr!\s*</div>\s*!, '' ],
                   ],
                   #Regex => qr!img\s+src\s*=\s*"(.*?(?:gif|png|jpg|jpeg))"!i,
                   #ExtraImgAttrsRegex => qr!((alt=".*?")\s*(title=".*"))!i,
                   #TitleRegex => qr!class="comicpane".*title="(.*?)"!i,
                   #ExtraImgAttrs => qr!class="comicpane".*(alt=".*?")!i,
		  };
