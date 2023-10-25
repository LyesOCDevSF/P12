@RestResource(urlMapping='/Contract/*')
global with sharing class ContractAPIController {

    @HttpPost
    global static String createContract() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());

        String accountID = (String) requestBody.get('AccountId');
        String startDate = (String) requestBody.get('StartDate');
        String contractTerm = (String) requestBody.get('ContractTerm');

        Contract newContract = new Contract(
            AccountId = accountID,
            StartDate = Date.valueOf(startDate),
            ContractTerm = Integer.valueOf(contractTerm)
        );

        insert newContract;

        return newContract.Id;
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
