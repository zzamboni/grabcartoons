TARGZFILE=$(HOME)/.www/files/grabcartoons.tar.gz

all:
	@echo "Valid Targets: install-ceriaslocal targz. Use with care."

install-ceriaslocal: .install-ceriaslocal

.install-ceriaslocal:
	cd /usr/ceriaslocal; rm -rf grabcartoons; cvs -d $(HOME)/cvsroot export -Dtoday -d grabcartoons tools/grabcartoons; chmod -R go=u,go-w grabcartoons
	touch .install-ceriaslocal

targz: install-ceriaslocal
	cd /usr/ceriaslocal; tar zcvf $(TARGZFILE) grabcartoons; chmod a+r $(TARGZFILE)
