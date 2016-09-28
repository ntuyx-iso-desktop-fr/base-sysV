include Makefile.inc

DIRMAN = man

DIRTOOLS = tools

DIRSCRIPTS = scripts


.PHONY: all


all:
	$(MAKE) -C $(DIRTOOLS) all
	$(MAKE) -C $(DIRSCRIPTS) all
	$(MAKE) -C $(DIRMAN) all

install: all

	$(MAKE) -C $(DIRTOOLS) install
	$(MAKE) -C $(DIRSCRIPTS) install
	$(MAKE) -C $(DIRMAN) install
man:
	$(MAKE) -C $(DIRMAN) man
clean:

	$(MAKE) -C $(DIRSCRIPTS) clean
	$(MAKE) -C $(DIRMAN) clean

dist: distclean

	rm -rf $(NAME) $(NAME).tar.gz
	git archive --format=tar --prefix=$(NAME)/ HEAD | tar -x
	git log > $(NAME)/ChangeLog
	tar czvf $(NAME).tar.gz $(NAME)
	rm -rf $(NAME)

distclean:

	$(MAKE) -C $(DIRSRC) distclean
