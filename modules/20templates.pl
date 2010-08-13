# Templates for comics.com strips, in both large and small formats.
$TEMPLATE{'comics.com'} = {
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
	  eval '$H->{_Comics}='.$comics;
	  return ($H->{_Template_Name}, "Internal error in template '$H->{_Template_Name}': $@") if $@;
	  $ch=$H->{_Comics};
	  foreach $k (keys(%$ch)) {
	    # We don't need the long descriptions
	    delete($ch->{$k}->{Description});
	    # Replace the ID keys with the comic's "tag"
	    $ch->{$ch->{$k}->{URL}}=$ch->{$k};
	    delete($ch->{$k});
	  }
	  vmsg("    Got comics list from comics.com\n");
	  return ($H->{_Template_Name}, undef);
	}
      }
      return($H->{_Template_Name}, "Could not find the list of comics for template '$H->{_Template_Name}' in $H->{Base}");
    },
    '_Template_Code' => sub { $H=shift;
      # If a tag was manually set, respect it
      unless ($H->{Tag}) {
	# Otherwise, try to derive it from the comic's title
	my $title=lc($H->{Title});
	# Make sure we have a valid tag
	$ch=$H->{_Comics};
	vmsg("    [tmpl:$H->{_Template_Name}] Trying to find the tag for '$title'\n");
	# First, see if the title is a valid tag already.
	if ($ch->{$title}) {
	  # If so, store it as tag and replace the title with the appropriate comic name
	  $H->{Tag}=$title;
	  $H->{Title}=$ch->{$title}->{Comic};
	  vmsg("      [tmpl:$H->{_Template_Name}] Done - comic title was the tag\n");
	}
	else {
	  # Second, search for the title in the comics we know
	  vmsg("      [tmpl:$H->{_Template_Name}] Looking for the comic's title '$title' in the list of comics\n");
	  my $tag=(grep { lc($ch->{$_}->{Comic}) eq $title } keys(%$ch))[0];
	  # If that doesn't work, try some blind normalization
	  if ($tag) {
	    vmsg("      [tmpl:$H->{_Template_Name}] Found the title in the list of comics\n");
	  }
	  else {
	    vmsg("      [tmpl:$H->{_Template_Name}] Title not found in comics list - trying some normalization\n");
	    $tag=$title;
	    $tag=~s/\s+\&\s+/&/g;
	    $tag=~s/\.//g;
	    $tag=~s/'//g;
	    $tag=~s/\s/_/g;
	  }
	  $H->{Tag} = $tag;
	  # Set the proper title if we can
	  if (exists($ch->{$tag})) {
	    $H->{Title} = $ch->{$tag}->{Comic};
	  }
	}
	# No matter how we got the tag, check that it is valid
	die "[tmpl:$H->{_Template_Name}] Error: Could not find comic '$H->{Tag}'\n" unless exists($ch->{$H->{Tag}});
      }
      # No matter how we got the tag, check that it is valid
      return($H->{Title}||$H->{_Template_Name}, "Error: Could not find comic '$H->{Tag}' in template '$H->{_Template_Name}'") unless exists($ch->{$H->{Tag}});
    }
};

# Template for gocomics.com
$TEMPLATE{'gocomics.com'} = {
    '_Template_Description' => "Comics hosted at gocomics.com",
    'Base' => 'http://www.gocomics.com',
    'Page' => '{Base}/{Tag}/',
    'Regex' => qr(link rel=\"image_src\" href=\"(http://.*\.gocomics\.com/.*)\")i,
    '_Template_Code' => sub { $H=shift; unless ($H->{Tag}) { my $tag=lc($H->{Title}); $tag=~s/\s//g; $H->{Tag} = $tag } },
};
