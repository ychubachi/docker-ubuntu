USERNAME=ychubachi
IMAGENAME=${USERNAME}/ubuntu:latest

ifeq ($(OS),Windows_NT)
	PWD=$(CURDIR)
endif

.PHONY: build
build: Dockerfile
	docker image build -f Dockerfile -t ${IMAGENAME} .

.PHONY: push
push:
	docker push ${IMAGENAME}

.PHONY: pull
pull:
	docker pull ${IMAGENAME}

.PHONY: shell
shell:
	docker container run -it --rm -v ${PWD}:/docker ${IMAGENAME}

.PHONY: clean
clean:
	docker container prune

.PHONY: remove
doomsday:
	docker image rm -f `docker image ls -q`
