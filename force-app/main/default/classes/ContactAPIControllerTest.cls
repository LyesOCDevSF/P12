@isTest
private class ContactAPIControllerTest {

    @isTest static void testCreateContact() {
        // creation d'un contact dans un body fictif
        String requestBody = '{"firstName": "John", "lastName": "Doe", "email": "john.doe@example.com"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        // Utilisation de blob pour representer la requete http de test 
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;

        // demarrage du test 
        Test.startTest();
        String newContactId = ContactAPIController.createContact();
        Test.stopTest();

        // Assertion pour acter que le contact a bien été créé
        Contact newContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :newContactId];
        System.assertEquals('John', newContact.FirstName);
        System.assertEquals('Doe', newContact.LastName);
        System.assertEquals('john.doe@example.com', newContact.Email);
    }

    @isTest static void testUpdateContact() {
        // Creation d'un contact à mettre à jour 
        Contact existingContact = new Contact(FirstName = 'Jane', LastName = 'Doe', Email = 'jane.doe@example.com');
        insert existingContact;

        String requestBody = '{"contactId": "' + existingContact.Id + '", "firstName": "Updated Jane", "lastName": "Updated Doe", "email": "updated.jane.doe@example.com"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        // utilisation de blob pour simuler une requete 
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;

        // test update
        Test.startTest();
        String updatedContactId = ContactAPIController.updateContact();
        Test.stopTest();

        // Assertion pour verifier que le contact à bien été mis a jour
        Contact updatedContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :updatedContactId];
        System.assertEquals('Updated Jane', updatedContact.FirstName);
        System.assertEquals('Updated Doe', updatedContact.LastName);
        System.assertEquals('updated.jane.doe@example.com', updatedContact.Email);
    }

    @isTest static void testDeactivateContact() {
        // Arrange
        Contact existingContact = new Contact(FirstName = 'Jane', LastName = 'Doe', Email = 'jane.doe@example.com', IsActive__c = true);
        insert existingContact;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/Contact/' + existingContact.Id;
        RestContext.request = req;
        RestContext.response = res;

        // Démarrage du test 
        Test.startTest();
        String deactivatedContactId = ContactAPIController.deactivateContact();
        Test.stopTest();

        // Assertion pour vérifier que le champ IsActive est décoché 
        Contact deactivatedContact = [SELECT Id, IsActive__c FROM Contact WHERE Id = :deactivatedContactId];
        System.assertEquals(false, deactivatedContact.IsActive__c);
    }

}
