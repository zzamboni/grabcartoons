# Edit install prefix
PREFIX=/usr/local

TARGZFILE=grabcartoons-$(VERSION).tar.gz
TARGZDIR=$(HOME)/tmp

all:
	@echo "Valid Targets: install targz. Use with care."

install:
	mkdir -p -m 755 $(PREFIX)/bin
	mkdir -p -m 755 $(PREFIX)/lib/grabcartoons/modules
	install -m 755 grabcartoons.pl $(PREFIX)/bin
	install -m 644 modules/*.pl $(PREFIX)/lib/grabcartoons/modules

targz:
	cd $(TARGZDIR); rm -rf grabcartoon*; cvs -d zamboni@cvs.grabcartoons.sourceforge.net:/cvsroot/grabcartoons export -Dtoday -d grabcartoons-$(VERSION) grabcartoons; tar zcvf $(TARGZFILE) grabcartoons-$(VERSION)
