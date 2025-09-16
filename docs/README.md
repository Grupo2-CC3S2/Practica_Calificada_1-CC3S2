# sprint 1
- Configuración de variables de entorno

    | Variable | Efecto observable                  |
    |----------|----------------------------------|
    | PORT     | Puerto en que el servidor escucha|
    | MESSAGE  | Texto mostrado en respuesta HTTP |
    | RELEASE  | Versión usada en empaquetado     |

- Creación del archivo main.sh que es un script Bash que crea un servidor web muy simple y básico

- Creación de tablas de posibles resultados como éxito y errores.

    | Código | Efecto observable                  |
    |----------|----------------------------------|
    | 0     | éxito|
    | 1     | error de configuración (variables de entorno inválidas)|
    | 2  | dependencia faltante (ej: netcat no instalado) |
    | 3  | error de red (puerto ocupado, conexión fallida)     |
    | 4  | error DNS     |
    | 5  | error TLS     |
