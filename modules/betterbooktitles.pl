$COMIC{betterbooktitles} = {
    'Title' => 'Better Book Titles',
    'Page'  => 'https://betterbooktitles.tumblr.com',
    'RedirectMatch' => qr/class="post_title"/,
    'RedirectURLCapture' => qr/href="(.*?)"/,
    'Regex' => qr!id="cover".*src="(https://\d+.media.tumblr.com/.*.jpg)"!i,
};
