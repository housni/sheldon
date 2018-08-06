.DEFAULT_GOAL := all
FILES ?=

.PHONY: all
all: build lint test

.PHONY: build
build:
	docker build --rm -t sheldon:0.1 .

.PHONY: lint
lint:
	docker run --rm --name=sheldon-container -v $(CURDIR):/usr/lib/sheldon -w /usr/lib/sheldon -it sheldon:0.1 lint ${FILES}

.PHONY: test
test:
	docker run --rm --name=sheldon-container -v $(CURDIR):/usr/lib/sheldon -w /usr/lib/sheldon -it sheldon:0.1 test ${FILES}

gen-docs: