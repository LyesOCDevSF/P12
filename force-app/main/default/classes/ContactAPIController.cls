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

    public static HttpResponse updateContactInAXG(String contactId, String firstName, String lastName, String email) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(AXG_ENDPOINT + '/' + contactId);  // Supposons que l'endpoint pour mettre à jour un contact soit basé sur l'ID du contact
        request.setMethod('PUT');  
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Création du corps de la requête avec les détails du contact mis à jour
        Map<String, String> contactDetails = new Map<String, String>{
            'firstName' => firstName,
            'lastName' => lastName,
            'email' => email
        };
        request.setBody(JSON.serialize(contactDetails));
    
        HttpResponse response = http.send(request);
    
        if(response.getStatusCode() != 200) {  // 200 OK est souvent utilisé pour indiquer que la mise à jour a été réussie
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    
        return response;
    }


}