PREFIX 	:= ""
BINDIR	:= $(PREFIX)/usr/bin
LIBDIR 	:= "/usr/local/lib/bash/5.17"

define setup
	@mkdir -p "${LIBDIR}"
	@install -m 755 ./lib/*.sh "${LIBDIR}"
	@install -m 755 ./src/delphi.sh $(BINDIR)/delphi
	@echo "installed"
endef

define remove
	@rm -f "${LIBDIR}/alternatives.sh"	\
	"${LIBDIR}/colorsh.sh" 			 	\
	"${LIBDIR}/math.sh" 			  	\
	"${LIBDIR}/osutils.sh" 			   	\
	"${LIBDIR}/tuiutils.sh" 			\
	"${LIBDIR}/yamlparser.sh" 			\
	"${LIBDIR}/check.sh"				\
	"$(BINDIR)/delphi"
	@echo "uninstalled"
endef

install:
	$(setup)

uninstall:
	$(remove)

reinstall:
	@$(remove)
	@$(setup)