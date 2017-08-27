.PHONY: frontend

all: compile

release: frontend
	./rebar3 release

compile:
	./rebar3 compile

run: compile
	erl \
		-env ERL_LIBS _build/default/lib \
		+K true \
		-boot start_sasl \
		-config config/app \
		-name messenger \
		-s messenger

db-setup:
	psql -d postgres < sql-scripts/init/script.sql
	psql -d mydreams -U mydreams < sql-scripts/populate/script.sql

db-drop:
	psql -d postgres -c "DROP DATABASE IF EXISTS mydreams"
	psql -d postgres -c "DROP ROLE IF EXISTS mydreams"

db-reset: db-drop db-setup

test:
	./integration_tests/protocol_test.rb

frontend:
	$(MAKE) -C ./frontend

deploy:
	ansible-playbook -vv -i deployment/hosts deployment/playbook.yml
