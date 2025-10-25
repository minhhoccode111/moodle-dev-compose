
.PHONY: up down build restart clean

build:
	docker compose build --no-cache

up:
	docker compose up --build --force-recreate -d

up-tms:
	docker compose --profile tms up --build --force-recreate -d

restart:
	docker compose restart

down:
	docker compose down

clean:
	docker compose down -v

