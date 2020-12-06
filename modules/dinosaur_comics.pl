$COMIC{dinosaur_comics} = {
               Title => 'Dinosaur Comics',
                Base => 'https://www.qwantz.com',
                Page => '{Base}/index.php',
               Regex => qr!img src="(comics/[^"]*?\.(?:png|gif|jpg|jpeg))" class="comic"!i,
             Prepend => "{Base}/",
  ExtraImgAttrsRegex => qr!img src="(comics/[^"]*?\.(?:png|gif|jpg|jpeg))" class="comic" (title=".*?")!i,
          TitleRegex => qr@<span class="rss-title">([^<]*?)</span>@i,
};
