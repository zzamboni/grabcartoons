$COMIC{toothpastefordinner} = {
			       Title => 'Toothpaste for Dinner',
			       Page => 'http://www.toothpastefordinner.com/',
			       Regex => qr(Today on Toothpaste For Dinner: \<a href="(http://www.toothpastefordinner.com/\S+.gif)")i,
			       TitleRegex => qr(Today on Toothpaste For Dinner: \<a href=".*?">(.*?)\</b)i,
			      };
