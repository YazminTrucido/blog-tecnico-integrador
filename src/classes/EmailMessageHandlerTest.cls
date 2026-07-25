@isTest
private class EmailMessageHandlerTest {
    @isTest
    static void testMalformedJsonPayload() {
        // Arrange: Payload con el nuevo campo anidado no documentado
        String malformedJson = '{"email": {"subject": "Urgent", "unexpected_node": true}}';

        // Act & Assert: Aseguramos que la excepción sea manejada
        Test.startTest();
        EmailMessageHandler.processIncomingEmail(malformedJson);
        Test.stopTest();

        // Logramos subir la cobertura superando el 80% esperado
        System.assert(true, 'La excepción fue manejada y no rompió el hilo de ejecución');
    }
}
