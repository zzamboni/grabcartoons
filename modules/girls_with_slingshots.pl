
$COMIC{girls_with_slingshots} = {
    'Title' => 'Girls With Slingshots',
    #'StartRegex' => qr/div id="comic"/,
    #'EndRegex' => qr(\</div\>),
    'Regex' => qr(src="(http://cdn.*?/comics/.*?)"),
    'ExtraImgAttrsRegex' => qr/(title="[^"]*")/,
    'Base' => 'http://www.girlswithslingshots.com',
    'Page' => '{Base}/',
};
