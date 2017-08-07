$COMIC{ctrlaltdel} = {
                      Title => 'Ctrl+Alt+Del',
                      Base => 'http://www.cad-comic.com/cad/',
                      Page => '{Base}',
                      Regex => qr!src="(http://.*cdn\d*.cad-comic.com/comics.*?)"!i,
                      #Prepend => '{Base}',
                     };
