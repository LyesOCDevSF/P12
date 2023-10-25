@isTest
private class ContactAPIControllerTest {
    
    // Implémenter une classe mock pour simuler les réponses HTTP
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implémenter la méthode respond
        public HTTPResponse respond(HTTPRequest req) {
            // Créer une réponse factice
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            // Définir le corps et le statut en fonction de l'URL de la requête
            if(req.getEndpoint().endsWith('/john.doe@example.com')) {
                res.setBody('{"firstName": "John", "lastName": "Doe", "email": "john.doe@example.com"}');
                res.setStatusCode(200);
            } else if(req.getMethod() == 'POST') {
                res.setBody('{"id": "newContactId"}');
                res.setStatusCode(201);
            } else if(req.getMethod() == 'PUT') {
                res.setBody('{"success": true}');
                res.setStatusCode(200);
            } else {
                res.setStatusCode(404);
            }
            
            return res;
        }
    }
    
    @isTest static void testGetContactFromAXG() {
        // Configurer le mock
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        // Appeler la méthode
        HttpResponse res = ContactAPIController.getContactFromAXG('john.doe@example.com');
        Test.stopTest();
        
        // Vérifier la réponse
        System.assertEquals(200, res.getStatusCode());
    }
    
    @isTest static void testCreateContactInAXG() {
        // Configurer le mock
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        // Appeler la méthode
        HttpResponse res = ContactAPIController.createContactInAXG('John', 'Doe', 'john.doe@example.com');
        Test.stopTest();
        
        // Vérifier la réponse
        System.assertEquals(201, res.getStatusCode());
    }
    
    @isTest static void testUpdateContactInAXG() {
       // Configurer le mock
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
       Test.startTest();
       // Appeler la méthode
       HttpResponse res = ContactAPIController.updateContactInAXG('contactId', 'John', 'Doe', 'john.doe@example.com');
       Test.stopTest();
       
       // Vérifier la réponse
       System.assertEquals(200, res.getStatusCode());
    }
}
