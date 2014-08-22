$COMIC{robot_hugs} = {
        Title => 'Robot Hugs',
        Page => 'http://www.robot-hugs.com/',
        StartRegex => qr!<div id="comic">!,
        Regex => qr!img src="([^"]*\/comics\/[^."]+\.(?:gif|png|jpg|jpeg))"!i,
        TitleRegex => qr!img src.*comics.*alt="(.*?)"!,
        SkipLink => 1,
    };
