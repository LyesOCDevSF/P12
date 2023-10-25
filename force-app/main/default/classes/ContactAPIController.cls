@RestResource(urlMapping='/Contact/*')
global with sharing class ContactAPIController {
   

    //static final String AXG_ENDPOINT = 'https://crm-axg-endpoint.com/api/contacts';

    // Recherche d'un contact par son email
    
    public static HttpResponse getContactFromAXG(String email) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(AXG_ENDPOINT + '/' + email);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Received contact: ' + results);
        }
        return response;
}

    @HttpPost
    public static String createContactInAXG(String firstName, String lastName, String email) {
        //Recherche du contact existant par l'email avant creation 

        List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :email LIMIT 1];

        // Si le contact existant est trouvé son ID est retourné 
        if(!existingContacts.isEmpty()){

            return existingContacts[0].Id;
        }

        // Si aucun contact existant n'est trouvé => création du nouveau contact

        Contact newContact = new Contact(
            FirstName = firstname,
            LastName = lastname,
            Email = email
        );
        insert newContact;

        // Retourne l'Id du nouveau contact
        return newContact.Id;
    }

     @HttpPut
     public static String updateContact(String contactId, String firstname, String lastname, String Email){
        Contact existingContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        existingContact.FirstName = firstname;
        existingContact.LastName = lastname;
        existingContact.Email = email;
        update existingContact;
        return existingContact.Id;

     }  



}