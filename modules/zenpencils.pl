$COMIC{zenpencils} = {
    Title => 'Zen Pencils',
    Page => 'http://zenpencils.com/',
    StartRegex => qr!\<div id="comic"\>!,
    EndRegex => qr!\</div\>!,
    InclusiveCapture => 1,
    ExtraImgAttrsRegex => qr!(title=".*?")!i,
};
