include .env

config:
	$(eval HOST=$(shell read -p "Enter ip or hostname: " hostname; echo $$hostname))
	$(eval NAME=$(shell read -p "Enter config name: " name; echo $$name))
	$(eval TOKEN=$(shell printf "$(METHOD):$(PASSWORD)@$(HOST):8388" | base64))
	@echo "ss://$(TOKEN)#$(NAME)"
