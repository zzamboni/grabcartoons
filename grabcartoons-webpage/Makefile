grabcartoons.html: gr-pre.html gr-post.html lom.html
	cat gr-pre.html lom.html gr-post.html > grabcartoons.html

lom.html: ../grabcartoons/ChangeLog
	../grabcartoons/grabcartoons.pl --html > lom.html

install: .install

.install: grabcartoons.html cartoons-sample.html ../grabcartoons/ChangeLog
	cp grabcartoons.html cartoons-sample.html ../grabcartoons/ChangeLog ../htdocs
	sleep 2; touch .install

../grabcartoons/ChangeLog:
	cd ../grabcartoons; cvs -q upd

