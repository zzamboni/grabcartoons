$COMIC{buttersafe} = {
    Title => 'Buttersafe',
    Page => 'http://buttersafe.com/',
    Regex => qr!img +src="((.+?)/comics/(.+?))"!i,
    ExtraImgAttrsRegex => qr!(title=".*?")!i,
};
