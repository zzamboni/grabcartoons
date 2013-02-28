$COMIC{dinosaur_comics} = {
                     Title => 'Dinosaur Comics',
                      Base => 'http://www.qwantz.com',
                      Page => '{Base}/index.php',
                     Regex => qr!img\s+src\s*=\s*\"([^"]*?/comics/[^"]*?\.(?:png|gif|jpg|jpeg))\"[^<>]*class=\"comic\"!i,
        ExtraImgAttrsRegex => qr!img\s+src\s*=\s*\"(?:[^"]*?/comics/[^"]*?\.(?:png|gif|jpg|jpeg))\"[^<>]*class=\"comic\"[^<>]*(title=".*?")!i,
    };

