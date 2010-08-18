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

# Templates for comics.com strips
$TEMPLATE{'comics.com'} =
  {
   '_Template_Name' => 'comics.com',
   '_Template_Description' => "Comics hosted at comics.com",
   'Base' => 'http://comics.com',
   'Page' => '{Base}/{Tag}/',
   'Regex' => qr(img src="(http://.*\.com/dyn/str_strip/.*?\.full\.(gif|png|jpg))"),
   '_Init_Code' => sub {
     my $H=shift; my $C=shift;
     # If the comic already has a tag, skip the initialization, since we trust the tag is correct
     if ($C->{Tag}) {
       vmsg("  [tmpl:$H->{_Template_Name}] Skipping initialization for now, comic already has a tag (".$C->{Tag}.")\n");
       return undef;
     }
     vmsg("  [tmpl:$H->{_Template_Name}] Initializing.\n");
     # Get the list of comics from the website
     return ($H->{_Template_Name}, "Error fetching $H->{Base} to get list of comics") unless fetch_url($H->{Base}, 1);
     while (get_line()) {
       if (/CMC\.Comics\s+=\s+(.*);\s*$/) {
	 $comics=$1;
	 # $comics is a Javascript data structure - convert it to Perl, store it in the hash and sanitize it a bit
	 $comics =~ s/"Description":".*?","/"/g;
	 $comics =~ s/":/"=>/g;
	 $comics =~ s/\[\{/{/g;
	 $comics =~ s/\}\]/}/g;
	 eval '$ch='.$comics;
	 return ($H->{_Template_Name}, "Internal error in template '$H->{_Template_Name}': $@") if $@;
	 $H->{_Comics}={};
	 foreach $k (keys(%$ch)) {
	   # Copy just the information we need
	   $H->{_Comics}->{$ch->{$k}->{URL}}=$ch->{$k}->{Comic};
	 }
	 vmsg("    Got comics list from comics.com\n");
	 return ($H->{_Template_Name}, undef);
       }
     }
     return($H->{_Template_Name}, "Could not find the list of comics for template '$H->{_Template_Name}' in $H->{Base}");
   }
  };

# Template for gocomics.com
$TEMPLATE{'gocomics.com'} =
  {
   '_Template_Name' => 'gocomics.com',
   '_Template_Description' => "Comics hosted at gocomics.com",
   'Base' => 'http://www.gocomics.com',
   'Page' => '{Base}/{Tag}/',
   'Regex' => qr(link rel=\"image_src\" href=\"(http://.*\.gocomics\.com/.*)\")i,
   '_Template_Code' => sub { $H=shift; unless ($H->{Tag}) { my $tag=lc($H->{Title}); $tag=~s/\s//g; $H->{Tag} = $tag } },
  };

# Template for arcamax.com
$TEMPLATE{'arcamax.com'} = 
  {
   '_Template_Name' => 'arcamax.com',
   '_Template_Description' => "Comics hosted at arcamax.com",
   'Base' => 'http://www.arcamax.com',
   'Page' => '{Base}/{Tag}/',
   'Regex' => qr(img src=\"(http://www.arcamax.com/newspics/\d+/\d+/\d+.gif)\")i,
   '_Init_Code' => sub {
     my $H=shift; my $C=shift;
     # If the comic already has a tag, skip the initialization, since we trust the tag is correct
     if ($C->{Tag}) {
       vmsg("  [tmpl:$H->{_Template_Name}] Skipping initialization for now, comic already has a tag (".$C->{Tag}.")\n");
       return undef;
     }
     vmsg("  [tmpl:$H->{_Template_Name}] Initializing.\n");
     # Get the list of comics from the website
     return ($H->{_Template_Name}, "Error fetching $H->{Base}/comics/ to get list of comics") unless fetch_url("$H->{Base}/comics/", 1);
     $H->{_Comics} = {};
     $found = undef;
     while (get_line()) {
       if (m!class="sc-list" href="/(.+?)".*\>(.+?)\</a\>!) {
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

# Template for arcamax.com
$TEMPLATE{'comicskingdom.com'} =
  {
   '_Template_Name' => 'comicskingdom.com',
   '_Template_Description' => "Comics hosted at comicskingdom.com",
   'Base' => 'http://content.comicskingdom.net',
   'Function' => sub {
     my $C = shift;
     $C->{Tag}=$C->{Title};
     use POSIX qw(strftime);
     $tomorrow  = strftime("%Y%m%d", localtime(time + 86400));
     $today     = strftime("%Y%m%d", localtime);
     $yesterday = strftime("%Y%m%d", localtime(time - 86400));
     $tmpl = "$C->{Base}/$C->{Tag}/$C->{Tag}" . '.%s_large.gif';
     # Try the three dates, to see which one is active
     foreach $d ($today, $tomorrow, $yesterday) {
       $url=sprintf($tmpl, $d);
       if (fetch_url($url)) {
	 return(qq(<a href="http://newsok.com/entertainment/comics?feature_id=$C->{Tag}"><img src="$url"/></a>),
		$C->{Tag}, undef)
       }
     }
     return(undef, $C->{Tag}, "Could not find image for $C->{Tag}");
   },
  };
