# Edit install prefix
PREFIX=/usr/local

TARGZFILE=grabcartoons.tar.gz

all:
	@echo "Valid Targets: install targz. Use with care."

install:
	install -m 755 grabcartoons.pl $(PREFIX)/bin
	mkdir -p -m 755 $(PREFIX)/lib/grabcartoons/modules
	install -m 644 modules/*.pl $(PREFIX)/lib/grabcartoons/modules

targz: install-ceriaslocal
	cd /usr/ceriaslocal; tar zcvf $(TARGZFILE) grabcartoons; chmod a+r $(TARGZFILE)
