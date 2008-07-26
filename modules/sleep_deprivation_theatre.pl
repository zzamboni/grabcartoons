$COMIC{sleep_deprivation_theatre} = {
   Title => 'Sleep Deprivation Theatre',
   Base => 'http://drmoose.net',
   Page => '{Base}/sdt/',
   Regex => qr@src="(/images/sdt/SDT\d+\w+.gif)"@i,
   Prepend => '{Base}',
   NoShowTitle => 1
};
