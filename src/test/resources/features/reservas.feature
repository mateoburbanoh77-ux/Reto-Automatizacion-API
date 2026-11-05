Feature: Pruebas de la API de reservas

  Background:

    * url 'https://restful-booker.herokuapp.com'
    * configure headers = { Accept: 'application/json', 'Content-Type': 'application/json' }
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

  @crear

  Scenario: Crear una reserva

    Given path 'booking'
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

    * print 'ID de la reserva creada:', response.bookingid

  @consultar

  Scenario: Consultar una reserva existente

    # Preparación: crear una reserva para consultar

    Given path 'booking'
    And request datosReserva
    When method POST
    Then status 200
    And match response.bookingid == '#number'

    * def reservaId = response.bookingid

    # Consultar la reserva creada

    Given path 'booking', reservaId
    When method GET
    Then status 200
    And match response == datosReserva

  @actualizar

  Scenario: Actualizar una reserva

    # Preparación: crear una reserva para actualizar

    Given path 'booking'
    And request datosReserva
    When method POST
    Then status 200
    And match response.bookingid == '#number'

    * def reservaId = response.bookingid

    # Obtener el token de autenticación

    Given path 'auth'

    And request { username: 'admin', password: 'password123' }
    When method POST
    Then status 200
    And match response.token == '#string'

    * def token = response.token

    # Preparar los nuevos datos

    * copy datosActualizados = datosReserva
    * set datosActualizados.firstname = 'Nicolas Actualizado'
    * set datosActualizados.totalprice = 350
    * set datosActualizados.additionalneeds = 'Dinner'

    # Actualizar la reserva

    Given path 'booking', reservaId
    And cookie token = token
    And request datosActualizados
    When method PUT
    Then status 200
    And match response == datosActualizados

    # Verificar que los cambios quedaron guardados

    Given path 'booking', reservaId
    When method GET
    Then status 200
    And match response == datosActualizados

  @eliminar

  Scenario: Eliminar una reserva

    # Preparación: crear una reserva para eliminar

    Given path 'booking'
    And request datosReserva
    When method POST
    Then status 200
    And match response.bookingid == '#number'

    * def reservaId = response.bookingid

    # Obtener el token de autenticación

    Given path 'auth'

    And request { username: 'admin', password: 'password123' }
    When method POST
    Then status 200
    And match response.token == '#string'

    * def token = response.token

    # Eliminar la reserva

    Given path 'booking', reservaId
    And cookie token = token
    When method DELETE
    Then status 201

    # Verificar que la reserva ya no existe

    Given path 'booking', reservaId
    When method GET
    Then status 404

  @lista

  Scenario: Consultar la lista de reservas

    Given path 'booking'
    When method GET
    Then status 200
    And match response == '#array'
    And match each response == { bookingid: '#number' }
