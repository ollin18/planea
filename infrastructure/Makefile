init:
	@docker-compose up -d

rebuild:
	@docker-compose up --build -d
stop:
	@docker-compose stop

build:
	@docker-compose build

clean:
	@docker-compose rm

ingester:
	@docker build -t ingest:latest ingest/.
