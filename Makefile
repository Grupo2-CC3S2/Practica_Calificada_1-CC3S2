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

.PHONY: netcat
netcat: # Instala netcat para evitar errores al correr el servidor
	@echo "Instalando netcat..."
	@sudo apt update && sudo apt install -y netcat-openbsd
	@echo "Netcat instalado"
