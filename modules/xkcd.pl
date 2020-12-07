$COMIC{xkcd} = {
	Title => 'xkcd',
	Page => 'https://xkcd.com/',
	Regex => qr!img src="(?:https:)?//(imgs\.xkcd\.com/comics.*?)"!i,
	Prepend => 'https://',
	TitleRegex => qr!^<div id="ctitle">(.+)</div>!i,
	ExtraImgAttrsRegex => qr!(title=".*?")!i,
};
