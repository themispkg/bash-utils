path := "/usr/local/lib/bash/5.17"

install:
	mkdir -p /usr/local/lib/bash/5.17
	install -m 755 ./*.sh /usr/local/lib/bash/5.17

uninstall:
	@rm "${path}/alternatives.sh" "${path}/colorsh.sh" "${path}/math.sh" "${path}/osutils.sh" "${path}/tuiutils.sh" "${path}/yamlparser.sh"
	@echo "uninstalled"

reinstall:
	@rm "${path}/alternatives.sh" "${path}/colorsh.sh" "${path}/math.sh" "${path}/osutils.sh" "${path}/tuiutils.sh" "${path}/yamlparser.sh"
	@echo "uninstalled"
	install -m 755 ./*.sh /usr/local/lib/bash/5.17
