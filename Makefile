SHELL:=/bin/bash


make prep:
	@chmod +x ./scripts/startup.sh && chmod +x ./scripts/teardown.sh

start:
	@./scripts/startup.sh

stop:
	@./scripts/teardown.sh

awsLogin:
	@chmod +x ./scripts/awsLogin.sh && ./scripts/awsLogin.sh
