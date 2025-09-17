#!/usr/bin/env bats

setup() {
  make run
  for i in {1..5}; do
    if nc -z 127.0.0.1 8080; then
      break
    fi
    sleep 1
  done
}

teardown() {
  make stop
}


@test "Servidor está escuchando en el puerto 8080" {
  run nc -z 127.0.0.1 8080
  [ "$status" -eq 0 ]
}

@test "Servidor no responde a puerto equivocado" {
  run nc -z 127.0.0.1 8081
  [ "$status" -ne 0 ]
}

@test "Ejecución correcta de make client" {
  run make client
  [ "$status" -eq 0 ]
}

@test "Ejecución correcta de make check" {
  run make check
  [ "$status" -eq 0 ]
}

@test "Ejecución correcta de make run-procesos" {
  run make "run-procesos"
  [ "$status" -eq 0 ]

  make "stop-procesos" || true
}
