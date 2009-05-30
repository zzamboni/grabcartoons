# Edit install prefix
PREFIX=/usr/local

TARGZFILE=grabcartoons-$(VERSION).tar.gz
TARGZDIR=$(HOME)/tmp

# Defaults for the test target.
OUT:=t.html
C:=-a

all:
	@echo "Valid Targets: install targz. Use with care."

install:
	mkdir -p -m 755 $(PREFIX)/bin
	mkdir -p -m 755 $(PREFIX)/lib/grabcartoons/modules
	install -m 755 grabcartoons.pl $(PREFIX)/bin
	install -m 644 modules/*.pl $(PREFIX)/lib/grabcartoons/modules

targz:
	cd $(TARGZDIR); rm -rf grabcartoon*; svn export https://grabcartoons.svn.sourceforge.net/svnroot/grabcartoons/trunk/grabcartoons grabcartoons-$(VERSION) ; tar zcvf $(TARGZFILE) grabcartoons-$(VERSION)

test:
	./grabcartoons.pl -v $(C) > $(OUT)
	open $(OUT)
