# Grab the main comics page, and then redirect to the page corresponding
# to the first one on the list. Then grab all the images that form the
# comic and concatenate them.
$COMIC{oatmeal} = {
		   Title => 'The Oatmeal',
		   Base => 'http://theoatmeal.com',
		   Page => '{Base}/comics/',
		   RedirectMatch => 'href="/(?:comics|blog)/',
		   RedirectURLCapture => 'href="(/(?:comics|blog)/.*?)"',
		   RedirectURLPrepend => '{Base}',
		   Regex => qr((\<img src=".*/theoatmeal-img/comics/.*?".*?/>)),
		   MultipleMatches => 1,
		   Append => "<br/>",
		  };

