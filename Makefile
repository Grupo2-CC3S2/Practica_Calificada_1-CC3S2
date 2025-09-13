PORT ?= 8080


.DEFAULT_GOAL := help

.PHONY: help
help: # Muestra los targets disponibles
	@echo "Make targets:"
	@echo "make run"
# Solo funcionará en con WSL en Windows o en Linux

.PHONY: run
run: # Corre el servidor en el puerto especificado en segundo plano
	@echo "Iniciando el servidor en el puerto ${PORT}..."
	@bash src/main.sh ${PORT} >> server.log 2>&1 &
	@echo "Servidor iniciado. Escribe make stop para detenerlo."

.PHONY: stop
stop: # Detiene el servidor
	@echo "Deteniendo el servidor..."
	@fuser -k "${PORT}"/tcp >/dev/null 2>&1 
	@echo "Servidor detenido."
# También podemos usar 
# 1- lsof -i :8080
# 2- Guardas el PID en una variable
# 3- kill <PID>

.PHONY: check
check: # Verifica si el puerto 8080 está en uso
	@if lsof -i :8080 > /dev/null; then \
		echo "El puerto 8080 está en uso."; \
		lsof -i :8080 > port.log || true;\
	else \
		echo "El puerto 8080 está libre."; \
		lsof -i :8080 > port.log || true;\
	fi

.PHONY: client
client: #Usa curl para hacer una petición al servidor
	@echo "Haciendo petición en el puerto ${PORT}"
	@curl --max-time 2 127.0.0.1:${PORT} || true
	@echo "Petición realizada"

.PHONY: netcat
netcat: # Instala netcat para evitar errores al correr el servidor
	@echo "Instalando netcat..."
	@sudo apt update && sudo apt install -y netcat-openbsd
	@echo "Netcat instalado"
