# Practica_Calificada_1-CC3S2


## Makefile:
### Sprint-1:
Se crean las tareas principales como **make run**, **make stop** y tareas especificas como **make check** para revisar puertos, **make cliente** para ejecutar un registro del acceso al servidor y por último **make netcat** que instala netcast en el entorno para permitir el uso del comando **nc**


### Sprint-2:
Se crearon las tareas de **make run-procesos** para correr el script [procesos.log](src/procesos.sh) y guardar los resultados en el archivo **procesos.log** y de igual forma que el archivo [main.sh](src/main.sh) también se creó la tarea **make stop-procesos** para terminar el proceso ya que posee iteraciones infinitas, además para automatizar el proceso de correr el archivo **logs.sh** se crea la tarea **make collect-logs** para probar el último script creado [logs.sh](src/logs.sh) y con eso se acabarían la automatización de tareas con el archivo makefile y faltaría la verificación de dependencias.


### Sprint-3:
Como se basa principalmente en los testeos y la integración con DevSecOps, se completará el [Makefile](./Makefile) con la instalación de **bats** el cuál nos va a servir para testear archivos bash, por ello se crean las tareas **make test** para automatizar el proceso de testeo y para hacer la tarea más robusto y general, se creó la tarea **make clean** que lo que hace es que ejecuta todos los procesos de stop tanto como **stop** y **stop-procesos** para así mantener una limpieza general y por último ejecuta **make check** para verificar que efectivamente no hay ningún proceso en el puerto 8080.