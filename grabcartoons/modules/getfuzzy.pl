$COMIC{getfuzzy} = {
    'Title' => 'Get Fuzzy',
    'Base' => 'http://www.comics.com',
    'Page' => '{Base}/comics/getfuzzy/',
    'Regex' => qr/SRC="([\w.\/]+\.(gif|jpg|png))"[^<>]*ALT="Today's Comic"/i, 
    'Prepend' => '{Base}',
};
