# Automatización de API REST con Karate
Proyecto de pruebas automatizadas sobre **Restful Booker**, desarrollado con **Karate**, **Java 21** y **Maven**, e integrado con **Jenkins**.
Valida la consulta de reservas y su ciclo completo de creación, consulta, actualización y eliminación. Incluye comprobaciones de códigos HTTP, estructura JSON y consistencia de los datos.
## Tecnologías
| Herramienta | Uso |
|---|---|
| Java 21 | Entorno de ejecución |
| Karate 1.5.2 | Automatización y validación de la API |
| JUnit 5 | Ejecución de las pruebas |
| Maven | Gestión de dependencias y construcción |
| Jenkins | Integración continua |
| Git y GitHub | Control de versiones |
## API utilizada
**URL base:** https://restful-booker.herokuapp.com
**Documentación:** https://restful-booker.herokuapp.com/apidoc/index.html
Restful Booker es una API pública de práctica. La disponibilidad del servicio y los cambios realizados por otros usuarios pueden afectar las ejecuciones.
## Cobertura de pruebas
El proyecto contiene **dos escenarios**:
### 1. Consultar las reservas existentes
- Ejecutar una solicitud GET al listado de reservas.
- Validar el código HTTP 200.
- Verificar que la respuesta sea un arreglo.
- Comprobar que cada elemento contenga un `bookingid` numérico.
### 2. Validar el ciclo de vida de una reserva
| Paso | Operación | Resultado esperado |
|---|---|---|
| 1 | Crear una reserva mediante POST | HTTP 200, estructura válida y datos enviados |
| 2 | Consultar la reserva mediante GET | HTTP 200 y coincidencia de los datos |
| 3 | Solicitar un token de autenticación | HTTP 200 y token de tipo texto |
| 4 | Actualizar la reserva mediante PUT | HTTP 200 y datos actualizados |
| 5 | Consultar nuevamente la reserva | Persistencia de los cambios |
| 6 | Eliminar la reserva mediante DELETE | HTTP 201 |
| 7 | Consultar la reserva eliminada | HTTP 404 |
El identificador se obtiene de la respuesta de creación y se reutiliza durante el escenario. Las operaciones de actualización y eliminación utilizan el token generado por la API.
> Los códigos esperados corresponden al comportamiento de Restful Booker; por ejemplo, su operación DELETE devuelve HTTP 201.
## Estructura del proyecto
```text
Reto-Automatizacion-API/
├── src/
│   └── test/
│       ├── java/
│       │   └── com/reto/
│       │       └── ApiTest.java
│       └── resources/
│           └── features/
│               └── reservas.feature
├── evidencias/
├── .gitignore
├── Jenkinsfile
├── pom.xml
└── README.md
```
- **ApiTest.java:** runner de JUnit 5 que ejecuta los archivos Karate.
- **reservas.feature:** escenarios, solicitudes y validaciones.
- **Jenkinsfile:** definición del pipeline.
- **evidencias:** capturas de ejecución y resultados.
- **pom.xml:** dependencias y configuración de Maven.
  La carpeta `target/` se genera durante la ejecución y está excluida del control de versiones.
## Requisitos
- JDK 21.
- Apache Maven instalado y disponible en el PATH.
- Git.
- Conexión a internet para descargar dependencias y acceder a la API.
- Variable `JAVA_HOME` configurada con la ubicación del JDK.
  Verificar las herramientas:
```powershell
java -version
mvn -version
git --version
```
## Instalación
Clonar el repositorio y entrar en su carpeta:
```powershell
git clone https://github.com/mateoburbanoh77-ux/Reto-Automatizacion-API.git
cd Reto-Automatizacion-API
```
## Ejecución de las pruebas
Desde la carpeta que contiene `pom.xml`:
```powershell
mvn clean test
```
Para ejecutar específicamente el runner:
```powershell
mvn "-Dtest=ApiTest" test
```
Una ejecución satisfactoria debe finalizar con:
```text
Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```
También se puede ejecutar `ApiTest.java` directamente desde IntelliJ IDEA.
## Reportes
### Reporte HTML de Karate
Después de ejecutar las pruebas, abrir:
```text
target/karate-reports/karate-summary.html
```
El reporte permite consultar los escenarios, los pasos ejecutados y el detalle de las solicitudes y respuestas.
Desde PowerShell:
```powershell
Start-Process .\target\karate-reports\karate-summary.html
```
### Resultados JUnit
Maven genera los resultados XML en:
```text
target/surefire-reports/TEST-*.xml
```
Jenkins utiliza estos archivos para mostrar el total de pruebas y sus resultados.
## Integración continua
El repositorio incluye un pipeline declarativo definido en `Jenkinsfile`, preparado para ejecutarse en Windows.
### Herramientas de Jenkins
| Herramienta | Nombre configurado |
|---|---|
| JDK 21 | `Java21` |
| Maven | `Maven3` |
| Git | Ejecutable disponible en el agente |
Los nombres de JDK y Maven deben coincidir con los definidos en el pipeline.
### Configuración del trabajo
| Campo | Valor |
|---|---|
| Tipo de trabajo | Pipeline |
| Definition | Pipeline script from SCM |
| SCM | Git |
| Repository URL | `https://github.com/mateoburbanoh77-ux/Reto-Automatizacion-API.git` |
| Branch Specifier | `*/master` |
| Script Path | `Jenkinsfile` |
El repositorio público permite su lectura sin credenciales.
### Flujo del pipeline
1. Obtener el código desde GitHub.
2. Verificar Java, Maven y Git.
3. Ejecutar `mvn -B clean test`.
4. Publicar los resultados JUnit.
5. Archivar los reportes de Karate.
   El pipeline evita ejecuciones simultáneas del mismo trabajo, conserva las últimas diez ejecuciones y establece un tiempo máximo de quince minutos.
### Activación
La primera ejecución se inicia con **Construir ahora**.
Después, Jenkins consulta el repositorio aproximadamente cada cinco minutos mediante `pollSCM`. Si detecta nuevos commits, inicia una ejecución.
El equipo y Jenkins deben permanecer encendidos para realizar estas comprobaciones y ejecutar las pruebas.
### Consultar los resultados
Dentro de cada ejecución:
- **Console Output:** registro de la ejecución y estado final.
- **Resultado de los tests:** pruebas ejecutadas y fallos.
- **Artefactos:** reportes de Karate archivados.
  Para consultar el reporte completo, descargar los artefactos como ZIP, extraerlos y abrir `karate-summary.html`.
## Evidencias de ejecución
La carpeta [`evidencias`](evidencias/) contiene capturas de:
- La ejecución del pipeline en Jenkins.
- Los resultados de las pruebas.
- El reporte HTML de Karate.
  Jenkins está instalado localmente. Las direcciones `localhost` o `127.0.0.1` solo son accesibles desde el equipo donde se ejecuta; las evidencias permiten revisar los resultados sin acceder a esa instancia.
