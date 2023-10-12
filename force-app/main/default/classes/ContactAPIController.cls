@RestResource(urlMapping='/contactAPI/*')
public with sharing class ContactAPIController {
   
    // Recherche d'un contact par son email
    @HttpRequest
    global static Contact getContactByEmail(){

        RestRequest req = RestContext.request;
        String email = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = :email LIMIT 1];
        return contact;
    }

}