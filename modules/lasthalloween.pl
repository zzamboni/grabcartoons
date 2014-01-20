$COMIC{lasthalloween} = {
    Title => 'The Last Halloween',
    Base => 'http://www.last-halloween.com',
    Page => '{Base}/posts/latest',
    SkipLink => 1,
    StartRegex => qr(\<div class="comic-container".*\>),
#    EndRegex => qr(\</div\>),
    EndRegex => qr(\<div class="comic-navigation-container".*\>),
    InclusiveCapture => 1,
    SubstOnRegexResult => [ 
                            [ qr(\<div class="comic-navigation-container".*\>), '<!-- deleted -->', 0 ],
                            [ qr(class="comic-container".*\>), '>', 1] 
                          ],
};
