$COMIC{wallyandosborne} = {
    Title => 'Wally and Osborne',
    Page => 'http://www.wallyandosborne.com/',
    Regex => qr!<img src=['"](http://(?:www\.)?wallyandosborne.com\/[^"']*/\d+-\d+-\d+-\d+\.(?:gif|png|jpg|jpeg))["']!i,
    ExtraImgAttrsRegex => qr!(title=".*")!,
};
