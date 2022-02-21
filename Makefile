path := "/usr/local/lib/bash/5.17"

install:
	mkdir -p /usr/local/lib/bash/5.17
	install -m 755 ./lib/*.sh /usr/local/lib/bash/5.17
	install -m 755 ./src/delphi.sh /usr/bin/delphi

uninstall:
	@rm "${path}/alternatives.sh" "${path}/colorsh.sh" "${path}/math.sh" "${path}/osutils.sh" "${path}/tuiutils.sh" "${path}/yamlparser.sh" "/usr/bin/delphi"
	@echo "uninstalled"

reinstall:
	@rm "${path}/alternatives.sh" "${path}/colorsh.sh" "${path}/math.sh" "${path}/osutils.sh" "${path}/tuiutils.sh" "${path}/yamlparser.sh" "/usr/bin/delphi"
	@echo "uninstalled"
	mkdir -p /usr/local/lib/bash/5.17
	install -m 755 ./lib/*.sh /usr/local/lib/bash/5.17
	install -m 755 ./src/delphi.sh /usr/bin/delphi
