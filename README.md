# Automatización de APIs con Karate
Proyecto de pruebas automatizadas sobre la API pública Restful Booker.
Incluye consultas y un flujo completo de creación, actualización y
eliminación de reservas.
## Tecnologías
- Java 21
- Maven
- Karate 1.5.2
- JUnit 5
## Requisitos
- JDK 21.
- Maven instalado para ejecutar desde la terminal.
- Conexión a internet para descargar dependencias y acceder a la API.
## API utilizada
https://restful-booker.herokuapp.com
Documentación:
https://restful-booker.herokuapp.com/apidoc/index.html
## Estructura
- `pom.xml`: dependencias y configuración de Maven.
- `src/test/java/com/reto/ApiTest.java`: ejecutor de las pruebas.
- `src/test/resources/features/reservas.feature`: escenarios de prueba.
## Escenarios implementados
### 1. Consultar la lista de reservas
- Ejecuta GET /booking.
- Valida el código HTTP 200.
- Comprueba que la respuesta sea una lista.
- Valida que cada elemento contenga un bookingid numérico.
### 2. Crear, consultar, actualizar y eliminar una reserva
- Crea una reserva mediante POST.
- Valida la estructura y los datos de la respuesta.
- Guarda el ID generado y consulta la reserva mediante GET.
- Obtiene un token de autenticación.
- Actualiza la reserva mediante PUT.
- Consulta nuevamente para verificar los cambios guardados.
- Elimina la reserva mediante DELETE.
- Comprueba con GET que la reserva eliminada devuelve 404.
  El ID y el token se obtienen durante la ejecución.
  El flujo completo está dentro del mismo escenario y no depende
  del orden de ejecución de otros escenarios.
## Ejecución desde IntelliJ IDEA
1. Abrir el proyecto como proyecto Maven.
2. Configurar el JDK 21 y cargar las dependencias de Maven.
3. Abrir `src/test/java/com/reto/ApiTest.java`.
4. Ejecutar la clase mediante Run 'ApiTest'.
## Ejecución desde la terminal
Desde la carpeta raíz del proyecto:
```bash
mvn clean test
```
## Reportes
Después de la ejecución, abrir en un navegador:
`target/karate-reports/karate-summary.html`
La carpeta `target` se genera automáticamente y no se incluye
en el control de versiones.
## Consideraciones
- La API es pública y compartida; su disponibilidad y los cambios
  de otros usuarios pueden afectar las pruebas.
- Las credenciales utilizadas pertenecen al entorno público de práctica.
- El escenario elimina la reserva que crea si alcanza el paso DELETE.
- Si la ejecución falla antes de eliminarla, la reserva puede permanecer.
- En esta API, el POST de creación devuelve 200 y el DELETE exitoso 201.