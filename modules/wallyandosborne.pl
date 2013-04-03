$COMIC{wallyandosborne} = {
    Title => 'Wally and Osborne',
    Page => 'http://wallyandosborne.com/',
    Regex => qr!<img src=['"](http://wallyandosborne.com\/[^"']*/\d+-\d+-\d+-\d+\.(?:gif|png|jpg|jpeg))["']!i,
    ExtraImgAttrsRegex => qr!(title=".*")!,
};
