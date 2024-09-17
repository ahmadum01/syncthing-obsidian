SSL_ENABLED := true
DOMAIN := "yourdomain.com"       # only if SSL_ENABLED = true
EMAIL := your-email@example.com  # only if SSL_ENABLED = true


.PHONY: add_execute_permissions
add_execute_permissions:
	sudo chmod +x ./scripts/*

.PHONY: up
up: add_execute_permissions
	./scripts/up.sh ${SSL_ENABLED} ${DOMAIN}

.PHONY: down
down:
	docker compose --profile with_ssl down

.PHONY: setup_ssl
setup_ssl: add_execute_permissions
	./scripts/setup_ssl.sh ${SSL_ENABLED} ${DOMAIN} ${EMAIL}
