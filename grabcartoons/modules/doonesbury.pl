sub get_url_doonesbury {
    my $dbbase="http://www.doonesbury.com";
    #my $dbpage="$dbbase/strip/dailydose/index.cfm";
    my $dbpage="$dbbase/strip/dailydose/index.htm";
    my $title="Doonesbury";
    my $cmd="$WGET $dbpage";
    open CMD, "$cmd |" or do {
        $@="Error executing $cmd: $!";
        return (undef, $dbpage, $title);
    };
    while (<CMD>) {
        # if (/img src=".*(images.*comics.*db.*\.gif).*border="0"/i) {
        # Grrr.... akamai sillyness
        if (/img src="(http:\/\/a.*images.*comics.*db.*\.gif)".*border="0"/i) {
            return ($1, $dbpage, $title);
        }
    }
    $@="Could not find image in Doonesbury's page";
    return (undef, $dbpage, $title);
}

1;
