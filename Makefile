SHELL := /bin/bash

VERSION_POPPLER=22.05.0

compiler: compiler.Dockerfile
	docker build -f ${PWD}/compiler.Dockerfile -t jeylabs/poppler/compiler:latest --build-arg VERSION_POPPLER=$(VERSION_POPPLER) .

build: compiler
	docker build --no-cache -f ${PWD}/builder.Dockerfile -t jeylabs/poppler:latest .

distribution: build
	docker run --rm \
		--env ZIP_FILE_NAME=poppler-$(VERSION_POPPLER) \
		--volume ${PWD}/export:/export \
		--volume ${PWD}/runtime:/runtime \
		--volume ${PWD}/export.sh:/export.sh:ro \
		jeylabs/poppler:latest \
		/export.sh
