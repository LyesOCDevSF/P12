@RestResource(urlMapping='/Contact/*')
global with sharing class ContactAPIController {
   
    @HttpPost
    global static String createContact() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());

        String firstName = (String) requestBody.get('firstName');
        String lastName = (String) requestBody.get('lastName');
        String email = (String) requestBody.get('email');

        // Vérifie si un contact avec cette adresse e-mail existe déjà
        List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :email];
        if (existingContacts.size() > 0) {
            return existingContacts[0].Id;
        }

        Contact newContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email
        );

        insert newContact;

        return newContact.Id;
    }

    @HttpPut
    global static String updateContact() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;

    Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());

    String contactId = (String) requestBody.get('contactId');
    String firstName = (String) requestBody.get('firstName');
    String lastName = (String) requestBody.get('lastName');
    String email = (String) requestBody.get('email');

    Contact existingContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
    
    Boolean isModified = false;
    
    if (firstName != null && existingContact.FirstName != firstName) {
        existingContact.FirstName = firstName;
        isModified = true;
    }
    
    if (lastName != null && existingContact.LastName != lastName) {
        existingContact.LastName = lastName;
        isModified = true;
    }
    
    if (email != null && existingContact.Email != email) {
        existingContact.Email = email;
        isModified = true;
    }
    
    if (isModified) {
        update existingContact;
    }
    
    return existingContact.Id;
}

@HttpDelete
global static String deactivateContact() {
    RestRequest req = RestContext.request;
    String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
    Contact existingContact = [SELECT Id, IsActive__c FROM Contact WHERE Id = :contactId];
    existingContact.IsActive__c = false;
    update existingContact;
    return existingContact.Id;
}




}