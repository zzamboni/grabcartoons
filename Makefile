# Edit install prefix
PREFIX=/usr/local

TARGZFILE=grabcartoons-$(VERSION).tar.gz
TARGZDIR=$(HOME)/tmp

# Defaults for the test target, can be overriden by passing the
# corresponding variable to make, e.g. "make test C=sinfest V="

# Fetch all comics
C:=-a
# Set the output file accordingly to the comic
ifeq ($(C),-a)
	OUT:=all.html
else
	OUT:=$(C).html
endif
# Verbose by default
V:=-v

all:
	@echo "Valid Targets: install test. Use with care."

install:
	mkdir -p -m 755 $(PREFIX)/bin
	mkdir -p -m 755 $(PREFIX)/lib/grabcartoons/modules
	install -m 755 grabcartoons.pl $(PREFIX)/bin
	install -m 644 modules/*.pl $(PREFIX)/lib/grabcartoons/modules

test:
	./grabcartoons.pl $(V) "$(C)" > "$(OUT)"
	open "$(OUT)"

# Update the web pages branch. For developer use only
updweb:
	./grabcartoons.pl --htmllist > lom.html
	./grabcartoons.pl --templates | perl -pe 's!(\S+\.com)!<a href="http://$$1/">$$1</a>!' > templates.txt
	./grabcartoons.pl --help | sed '/default: /d' > usage.txt
	./grabcartoons.pl --version | sed 's/^GrabCartoons version //' > version.txt
	git co gh-pages
	mv lom.html templates.txt usage.txt version.txt _includes
	@echo "### You are now in the gh-pages branch. Please review and commit changes ###"
