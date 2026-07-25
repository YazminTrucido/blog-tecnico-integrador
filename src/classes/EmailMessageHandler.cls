public with sharing class EmailMessageHandler {
    public static void processIncomingEmail(String jsonPayload) {
        try {
            // Refactorización: Manejo dinámico para evitar falla silenciosa
            Map<String, Object> emailData = (Map<String, Object>) JSON.deserializeUntyped(jsonPayload);
            System.debug('Email procesado correctamente: ' + emailData.get('subject'));
        } catch (JSONException e) {
            // Acciones correctivas: Alertar al Duty Squad y registrar el error
            System.debug('Error de formato JSON en integración de Email: ' + e.getMessage());
            // Lógica para enviar alerta de Slack...
        }
    }
}
