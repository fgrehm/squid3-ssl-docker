current_dir:=$(shell pwd)
build_tag = 'squid3-ssl-build'

.PHONY: debs build_debs copy_debs

debs: build_debs copy_debs

build_debs:
	docker build -t $(build_tag) - < Dockerfile.build

copy_debs:
	@mkdir -p debs
	docker run -v $(current_dir)/debs:/src/debs $(build_tag) /bin/sh -c 'cp /src/*.deb /src/debs/'

release_debs:
	sudo chown ${USER}:${USER} debs/*
	tar -zcvf squid3-$(shell date +%Y%m%d).tgz debs/
