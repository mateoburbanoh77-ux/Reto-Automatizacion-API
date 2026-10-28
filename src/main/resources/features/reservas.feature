Feature: Pruebas de la API de reservas
  Background:
    * url 'https://restful-booker.herokuapp.com'
    * configure headers = { Accept: 'application/json' }
  Scenario: Consultar la lista de reservas
    Given path 'booking'
    When method GET
    Then status 200
    And match response == '#array'
    And match each response == { bookingid: '#number' }

  Scenario: Crear, consultar, actualizar y eliminar una reserva
    * def datosReserva =
     """
     {
       "firstname": "Mateo",
       "lastname": "Burbano",
       "totalprice": 250,
       "depositpaid": true,
       "bookingdates": {
         "checkin": "2027-01-10",
         "checkout": "2027-01-15"
       },
       "additionalneeds": "Breakfast"
     }
     """
   # Crear la reserva
    Given path 'booking'
    And header Content-Type = 'application/json'
    And request datosReserva
    When method POST
    Then status 200
    And match response ==
     """
     {
       "bookingid": "#number",
       "booking": {
         "firstname": "#string",
         "lastname": "#string",
         "totalprice": "#number",
         "depositpaid": "#boolean",
         "bookingdates": {
           "checkin": "#string",
           "checkout": "#string"
         },
         "additionalneeds": "#string"
       }
     }
     """
    And match response.booking == datosReserva

   # Guardar el ID generado
    * def reservaId = response.bookingid
    * print 'ID de la reserva creada:', reservaId
   # Consultar esa misma reserva
    Given path 'booking', reservaId
    When method GET
    Then status 200
    And match response == datosReserva

# Obtener un token para actualizar y eliminar
    Given path 'auth'
    And request { username: 'admin', password: 'password123' }
    When method POST
    Then status 200
    And match response.token == '#string'
    * def token = response.token
   # Preparar los datos actualizados
    * copy datosActualizados = datosReserva
    * set datosActualizados.firstname = 'Nicolas Actualizado'
    * set datosActualizados.totalprice = 350
    * set datosActualizados.additionalneeds = 'Dinner'
   # Actualizar la reserva completa
    Given path 'booking', reservaId
    And cookie token = token
    And request datosActualizados
    When method PUT
    Then status 200
    And match response == datosActualizados
   # Comprobar que los cambios quedaron guardados
    Given path 'booking', reservaId
    When method GET
    Then status 200
    And match response == datosActualizados
   # Eliminar la reserva creada en esta prueba
    Given path 'booking', reservaId
    And cookie token = token
    When method DELETE
    Then status 201
   # Verificar que la reserva ya no existe
    Given path 'booking', reservaId
    When method GET
    Then status 404