$COMIC{robot_hugs} = {
        Title => 'Robot Hugs',
        Page => 'http://www.robot-hugs.com/',
        StartRegex => qr!<div id="comic"!,
        Regex => qr!img[^>]*src="([^"]*\/(?:comics|www.robot-hugs.com\/wp-content\/uploads)\/[^."]+\.(?:gif|png|jpg|jpeg))[^"]*"!i,
        TitleRegex => qr!div.*comic.*img[^>]*src[^>]*alt="(.*?)"!,
        SkipLink => 1,
    };
