@RestResource(urlMapping='/contactAPI/*')
public with sharing class ContactAPIController {
   

    static final String AXG_ENDPOINT = 'https://crm-axg-endpoint.com/api/contacts';

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
}