$COMIC{nodwick} = {
    Title => 'Nodwick',
    Page => 'http://nodwick.humor.gamespy.com/gamespyarchive',
    Regex => qr(img src="http\://nodwick\.humor\.gamespy\.com/gamespyarchive/(strips/.*\.jpg)"),
    Prepend => '{Page}/',
};
