
$COMIC{jspowerhour} = {
    Title => 'Junior Scientist Power Hour',
    Page => 'http://www.jspowerhour.com/',

    #Regex => qr!<img[^>]*id="comic-img"[^>]*src="([^"]*)"!,
    #ExtraImgAttrsRegex => qr!(alt="[^"]*")!,

    StartRegex => qr(\<div id="comic"),
    EndRegex => qr(\<div id="contact"),
    InclusiveCapture => 1,

    SubstOnRegexResult => [
        [ qr([\s]+), ' ', 1 ],     # drop the whitespace
        [ qr(^.*<img), '<img', 0],  # drop the leading stuff
        [ qr(/>.*?<div id="description"> <h1>), '/></a><br><h1>'], # and the middle stuff
        [ qr(</div> <div class="clearfix">.*), '<a>'],  # now the trailing stuff
        [ qr(h1), 'h3'],  # downsize headers
        [ qr(class="[^"]*"), '', 1 ],   # clean up any classes
        [ qr(style="[^"]*"), '', 1 ],   # clean up any styles
        [ qr(<\s*p\s*>), '<p class="comic">', 1 ],   # clean up any styles
        [ qr(id="[^"]*"), '', 1 ],      # and any ids
    ],

};

