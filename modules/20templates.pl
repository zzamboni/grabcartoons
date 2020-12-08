=pod

=head1 TEMPLATES

Templates describe a generic way of fetching comics from sites that
host many of them.

A template is simply a comic definition, its elements will be merged
with those from the provided snippet. For example, the template hash
may contain the regex to be used to find the comic image in the
page, and it will be merged with the comic snippet that specifies
the title and tag for the specific comic wanted.

The following elements have special meaning in a template definition:

=over 4

=item * _Template_Name indicates the short name for the template.

=item * _Template_Descripton contains a longer descripton of the template.

=item * _Init_Code, if it exists, is executed with the template
snippet AND the (still unmerged) comic snippet as arguments. It is
meant to run only once, so it should return a true value if it
executes correctly. This is meant to allow the template to execute
one-time initialization code (e.g. get list of comics from the web
site). If _Init_Code returns undef, it will be executed again if
needed. The code can store any data in the hash it receives as
argument, and that data will be available for all other uses of the
template in the current run. See below for the format in which the
list of comics should be stored.

=item * _Template_Code, if it exists, will be executed with the merged
comic snippet as argument, every time a comic from the template is
requested. This code can modify the snippet appropriately, for example
to deduce the tag from the user-given title.

=back

If the _Comics element exists it should contains a list of comics
available from the template, in the following format (this is most
commonly populated by the _Init_Code function, although it could also
be hard-coded):

    $H->{_Comics} = {
        comictag1 => "Comic Title 1",
        comictag2 => "Comic Title 2",
        ...
    }

If the _Comics element exists, then the code automatically searches
the user-given comic title to determine the correct tag for the comic
(unless a Tag element is already specified).

=cut

use POSIX qw(strftime);

# Template for gocomics.com
$TEMPLATE{'gocomics.com'} =
  {
   '_Template_Name' => 'gocomics.com',
   '_Template_Description' => "Comics hosted at gocomics.com",
   'Base' => 'http://www.gocomics.com',
   # Temp value - should get fixed on lookup in _Template_Code
   'Page' => '{Base}/{Tag}/'.strftime('%Y/%m/%d/', localtime),
   'Regex' => qr(data-image="([^"]+)"),
   '_Template_Code' => sub {
     my $H=shift;
     $H->{Page} = "{Base}/$H->{_URLs}->{$H->{Tag}}";
   },
   '_Init_Code' => sub {
     my $H=shift; my $C=shift;
     vmsg("  [tmpl:$H->{_Template_Name}] Initializing.\n");
     # Get the list of comics from the website
     $listurl="$H->{Base}/comics/a-to-z/";
     return ($H->{_Template_Name}, "Error fetching $listurl to get list of comics") unless fetch_url($listurl, 1);
     $H->{_Comics} = {};
     $H->{_URLs} = {};
     $found = undef;
     $inregion = undef;
     $tag = undef;
     $title = undef;
     $url = undef;
     while (get_line()) {
       $inregion = 1 if m!gc-blended-link--primary!;
       $inregion = 0 if m!^</div>!;
       if ($inregion) {
           #print("DEBUG: >$_<\n");
           if (m!\<a [^>]*gc-blended-link--primary[^>]*href="/((.+?)(?:/.*?))"!) {
               $tag = $2;
               $url = $1;
           }elsif (m!media-heading[^>]*\>(.+?)\<!) {
               $title = $1;
           }
           if ($tag && $title && $url) {
               $H->{_Comics}->{$tag} = $title;
               $H->{_URLs}->{$tag} = $url;
               vmsg("  [tmpl:$H->{_Template_Name}] Found comic $title ($tag)\n");
               $found = 1;
               $tag = undef; $title = undef; $url = undef;
           }
       }
     }
     vmsg("    Got comics list from $H->{_Template_Name}\n") if $found;
     return $found ? ($H->{_Template_Name}, undef) : ($H->{_Template_Name}, "Could not find the list of comics for template '$H->{_Template_Name}' in $listurl");
   },
  };

# Template for comics.com, which has merged with gocomics.com
$TEMPLATE{'comics.com'} = $TEMPLATE{'gocomics.com'};

# Template for arcamax.com
$TEMPLATE{'arcamax.com'} = 
  {
   '_Template_Name' => 'arcamax.com',
   '_Template_Description' => "Comics hosted at arcamax.com",
   'Base' => 'http://www.arcamax.com',
   'Page' => '{Base}/{Tag}/',
   'Regex' => qr(img src=\"(/newspics/\d+/\d+/\d+.gif)\")i,
   'Prepend' => '{Base}',
   '_Init_Code' => sub {
     my $H=shift; my $C=shift;
     vmsg("  [tmpl:$H->{_Template_Name}] Initializing.\n");
     # Get the list of comics from the website
     return ($H->{_Template_Name}, "Error fetching $H->{Base}/comics/ to get list of comics") unless fetch_url("$H->{Base}/comics/", 1);
     $H->{_Comics} = {};
     $found = undef;
     while (get_line()) {
       if (m!<li><b><a href="/(.+?)/".*\>(.+?)\</a\>!) {
	 $tag = $1; $title = $2;
	 $H->{_Comics}->{$tag} = $title;
	 vmsg("  [tmpl:$H->{_Template_Name}] Found comic $title ($tag)\n");
	 $found = 1;
       }
     }
     vmsg("    Got comics list from arcamax.com\n") if $found;
     return $found ? ($H->{_Template_Name}, undef) : ($H->{_Template_Name}, "Could not find the list of comics for template '$H->{_Template_Name}' in $H->{Base}/comics/");
   }
  };
 
# Template for comicskingdom.com
$TEMPLATE{'comicskingdom.com'} =
  {
   '_Template_Name' => 'comicskingdom.com',
   '_Template_Description' => "Comics hosted at comicskingdom.com",
   'Base' => 'https://www.comicskingdom.com',
   'Page' => '{Base}/{Tag}',
   'Regex' => '<meta property="og:image" content="([^"]*)"',
   #   'Function' => sub {
   #  my $C = shift;
   #  use POSIX qw(strftime);
   #  $tomorrow  = strftime("%Y%m%d", localtime(time + 86400));
   #  $today     = strftime("%Y%m%d", localtime);
   #  $yesterday = strftime("%Y%m%d", localtime(time - 86400));
   #  $tmpl = "$C->{Base}/$C->{Tag}/$C->{Tag}" . '.%s_large.gif';
   #  # Try the three dates, to see which one is active
   #  foreach $d ($today, $tomorrow, $yesterday) {
   #    $url=sprintf($tmpl, $d);
   #    if (fetch_url($url, undef, 1)) {
   #	 return(qq(<a href="$C->{Page}"><img src="$url"/></a>), $C->{Title}, undef)
   #    }
   #  }
   #  return(undef, $C->{Title}, "Could not find image for $C->{Title} ($C->{Tag})");
   #},
   '_Init_Code' => sub {
     my $H=shift; my $C=shift;
     vmsg("  [tmpl:$H->{_Template_Name}] Initializing.\n");
     # Get the list of comics from the website
     $listurl='https://www.comicskingdom.com/';
     return ($H->{_Template_Name}, "Error fetching $listurl to get list of comics") unless fetch_url($listurl, 1);
     $page = get_fullpage();
     # The page is HTML encoded in Javascript. We must decode it to more easily get the list of comics.
     $page =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg;
     set_lines(map { "$_\n" } split("\n", $page));
     $H->{_Comics} = {};
     $found = undef;
     $inregion = undef;
     while (get_line()) {
       $inregion = 1 if m!comic-lists!i;
       $inregion = 0 if m!copyright-footer!i;
       if ($inregion) {
	 if (m!href=.*/(.+?) data-ref.*\>(.+)\</a\>!) {
	   $tag = $1; $title = $2;
	   $H->{_Comics}->{$tag} = $title;
	   vmsg("  [tmpl:$H->{_Template_Name}] Found comic $title ($tag)\n");
	   $found = 1;
	 }
       }
     }
     vmsg("    Got comics list from $H->{_Template_Name}\n") if $found;
     return $found ? ($H->{_Template_Name}, undef) : ($H->{_Template_Name}, "Could not find the list of comics for template '$H->{_Template_Name}' in $listurl");
   },
  };

# Template for comics that include their image in the default og:image property
# Looks for lines of this form:
# <meta property="og:image" content="(comic_image_url)">
$TEMPLATE{"og-image"} = {
    _Template_Name => 'og-image',
    _Template_Description => 'Comics that can be extracted from the og:image property on their page',
    Regex => qr!property="og:image" content="(.*?)"!,
    Tag => '',
};
