NAME = zkui
VERSION=2.0-SNAPSHOT

current_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: all build publish

all: build publish

build:
#	mvn clean install
	docker run -it --rm --name maven-zkui -v "$(current_dir)":/usr/src/app -w /usr/src/app maven mvn clean install
	cp config.cfg docker
	cp target/$(NAME)-*-jar-with-dependencies.jar docker
	docker build -t $(NAME):$(VERSION) --no-cache --rm docker
	rm docker/$(NAME)-*.jar
	rm docker/config.cfg

publish:
	docker tag $(NAME):$(VERSION) $(NAME):$(VERSION)
	docker tag $(NAME):$(VERSION) $(NAME):latest
	docker push $(NAME)

