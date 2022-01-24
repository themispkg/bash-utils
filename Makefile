install:
	mkdir -p /usr/local/lib/bash5.17
	cp -r ./*.sh /usr/local/lib/bash5.17

uninstall:
	rm /usr/local/lib/bash5.17/*

reinstall:
	rm /usr/local/lib/bash5.17/*
	mkdir -p /usr/local/lib/bash5.17
	cp -r ./*.sh /usr/local/lib/bash5.17