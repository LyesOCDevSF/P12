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

    @HttpPut
    global static String updateContract() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());

        String contractId = (String) requestBody.get('ContractId');
        String startDate = (String) requestBody.get('StartDate');
        String contractTerm = (String) requestBody.get('ContractTerm');

        Contract existingContract = [SELECT Id, StartDate, ContractTerm FROM Contract WHERE Id = :contractId];
        
        Boolean isModified = false;
        
        if (startDate != null && existingContract.StartDate != Date.valueOf(startDate)) {
            existingContract.StartDate = Date.valueOf(startDate);
            isModified = true;
        }
        
        if (contractTerm != null && existingContract.ContractTerm != Integer.valueOf(contractTerm)) {
            existingContract.ContractTerm = Integer.valueOf(contractTerm);
            isModified = true;
        }
        
        if (isModified) {
            update existingContract;
        }
        
        return existingContract.Id;
    }
}