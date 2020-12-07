$COMIC{ctrlaltdel} = {
  Title => 'Ctrl+Alt+Del',
  Base => 'https://www.cad-comic.com/',
  Page => '{Base}',
  Regex => qr!src="(https://.*/Strip.*?)"!i,
};
