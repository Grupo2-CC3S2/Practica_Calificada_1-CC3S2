#!/usr/bin/env bats

setup() {
  PORT=8080
  bash src/main.sh $PORT &
  SERVER_PID=$!
  # Esperar a que nc esté escuchando
  sleep 1
}

teardown() {
  lsof -ti tcp:$PORT | xargs -r kill -9
}

@test "Servidor responde en puerto por defecto (8080)" {
  run curl -s --max-time 2 127.0.0.1:$PORT
  [ "$status" -eq 0 ]
  echo "$output" | grep -Eq "La aplicación está funcionando en el puerto[[:space:]][0-9]+"
}