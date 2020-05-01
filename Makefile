########################################
##          Planea Pipeline           ##
##     Ollin Demian Langle Chimal     ##
########################################
# Based on https://github.com/nanounanue/pipeline-template/blob/master/Makefile

.PHONY: clean data lint init deps sync_to_gs sync_from_gs

########################################
##            Variables               ##
########################################

## Project Directory
PROJ_DIR:=$(shell pwd)

PROJECT_NAME:=$(shell cat .project-name)
PROJECT_VERSION:=$(shell cat .project-version)
DATE:=$(shell date +'%Y-%m-%d')

## Python Version
VERSION_PYTHON:=$(shell python -V)

SHELL := /bin/bash

## Airflow variables
AIRFLOW_GPL_UNIDECODE := yes

########################################
##       Environment Tasks            ##
########################################

init: prepare ##@dependencias Prepara la computadora para el funcionamiento del proyecto

prepare: deps
#	pyenv virtualenv ${PROJECT_NAME}_venv
#	pyenv local ${PROJECT_NAME}_venv

#pyenv: .python-version
#	@pyenv install $(VERSION_PYTHON)

deps: pip airdb

pip: requirements.txt
	@pip install -r $<

airdb:
	@source .env
	# --directory=$(AIRFLOW_HOME)
	@airflow initdb

info:
	@echo Project: $(PROJECT_NAME) ver. $(PROJECT_VERSION) in $(PROJ_DIR)
	@python --version
	@pip --version

deldata:
	@ yes | rm data/raw/* data/clean/*

getdata:
	@airflow backfill ingest -s $(DATE)

prune:
	@docker container prune
########################################
##          Infrastructure            ##
##    	   Execution Tasks            ##
########################################

create: ##@infrastructure Builds the required containers
	$(MAKE) --directory=infrastructure build

start: up ##@infraestructura Starts the Docker Compose and build the images if required
	$(MAKE) --directory=infrastructure init

stop: ##@infrastructure Stops the Docker Compose infrastructure
	$(MAKE) --directory=infrastructure stop

status: ##@infrastructure Infrastructure status
	$(MAKE) --directory=infrastructure status

destroy: ##@infrastructure Delete the docker images
	$(MAKE) --directory=infrastructure clean
	@docker rmi ollin18/planea:0.1 ingest:latest

nuke: ##@infrastructure Destroy all infrastructure (TODO)
	$(MAKE) --directory=infrastructure nuke

neo4j:
	@$(MAKE) --directory=infrastructure init

# neo4jrebuild:
#     @$(MAKE) --directory=infrastructure rebuild

ingest:
	@$(MAKE) --directory=infrastructure ingester

dockerbuild:
	@$(MAKE) --directory=infrastructure build

########################################
##           Data Sync Tasks          ##
########################################

sync_to_gs: ##@data Sincroniza los datos hacia GCP GS
	@gsutil -m rsync -R data/ $(GS_BUCKET)/data/

sync_from_gs: ##@data Sincroniza los datos desde GCP GS
	@gsutil -m rsync -R $(GS_BUCKET)/data/ data/

########################################
##          Project Tasks             ##
########################################

run:       ##@proyecto Ejecuta el pipeline de datos
	$(MAKE) --directory=$(PROJECT_NAME) run

setup: build install ##@proyecto Crea las imágenes del pipeline e instala el pipeline como paquete en el PYTHONPATH

build:
	$(MAKE) --directory=$(PROJECT_NAME) build

install:
	@pip install --editable .

uninstall:
	@while pip uninstall -y ${PROJECT_NAME}; do true; done
	@python setup.py clean

## Verificando dependencias
## Basado en código de Fernando Cisneros @ datank

EXECUTABLES = docker docker-compose docker-machine rg pip
TEST_EXEC := $(foreach exec,$(EXECUTABLES),\
				$(if $(shell which $(exec)), some string, $(error "${BOLD}${RED}ERROR${RESET}: $(exec) is not in the PATH")))