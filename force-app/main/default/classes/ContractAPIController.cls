@RestResource(urlMapping='/Contract/*')
global with sharing class ContractAPIController {

    static final String AXG_ENDPOINT = 'https://crm-axg-endpoint.com/api/contracts';

    // Recherche d'un contrat par son numéro
    public static HttpResponse getContractFromAXG(String contractNumber) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(AXG_ENDPOINT + '/' + contractNumber);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Received contract: ' + results);
        }
        return response;
    }

    // Création d'un contrat
    public static HttpResponse createContractInAXG(String contractName, Date startDate, Date endDate) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(AXG_ENDPOINT);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Création du corps de la requête avec les détails du contrat
        Map<String, Object> contractDetails = new Map<String, Object>{
            'contractName' => contractName,
            'startDate' => startDate,
            'endDate' => endDate
        };
        request.setBody(JSON.serialize(contractDetails));

        HttpResponse response = http.send(request);

        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }

        return response;
    }

    // Modification d'un contrat
    public static HttpResponse updateContractInAXG(String contractId, String contractName, Date startDate, Date endDate) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(AXG_ENDPOINT + '/' + contractId);  
        request.setMethod('PUT');  
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Création du corps de la requête avec les détails du contrat mis à jour
        Map<String, Object> contractDetails = new Map<String, Object>{
            'contractName' => contractName,
            'startDate' => startDate,
            'endDate' => endDate
        };
        request.setBody(JSON.serialize(contractDetails));

        HttpResponse response = http.send(request);

        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }

        return response;
    }
}
