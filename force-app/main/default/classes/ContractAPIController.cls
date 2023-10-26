@RestResource(urlMapping='/Contract/*')
global with sharing class ContractAPIController {

    @HttpPost
    global static String createContract() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
    
        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
    
        // 2léments du contrat 
        Id contactId = (Id) requestBody.get('ContactId');
        Date startDate = Date.valueOf((String) requestBody.get('StartDate'));
        Integer contractTerm = Integer.valueOf((String) requestBody.get('ContractTerm'));
        String status = (String) requestBody.get('Status');
    
        // Recherche du contact si pas de contact correspondant pas de contrat créé retournera null
        List<Contact> conts = [SELECT Id, Name, AccountId FROM Contact WHERE Id = :contactId];
        if (conts.size() == 0) {
            return null;
        }
        Contact cont = conts[0];
        Id accountId = cont.AccountId;
    
        // Si le contact a déjà un compte associé
        if (accountId != null) {
            Contract newContract = new Contract(
                AccountId = accountId,
                StartDate = startDate,
                ContractTerm = contractTerm,
                Status = status
            );
            insert newContract;
            return newContract.Id;
        }
    
        // Si le contact n'a pas de compte associé, création d'un nouveau compte
        Account newAccount = new Account(Name = 'act' + cont.Name);
        insert newAccount;
        cont.AccountId = newAccount.Id;
        update cont;
    
        Contract newContract = new Contract(
            AccountId = newAccount.Id,
            StartDate = startDate,
            ContractTerm = contractTerm,
            Status = status
        );
        insert newContract;
        return newContract.Id;
    }
    

    @HttpPut
    global static String updateContract() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());

        String contractId = (String) requestBody.get('ContractId');  // L'Id de Salesforce est utilisé pour identifier le contrat.
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

   /* @HttpDelete
    global static String deactivateContract() {
        RestRequest req = RestContext.request;
        String contractId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        Contract existingContract = [SELECT Id, Status FROM Contract WHERE Id = :contractId];
        existingContract.Status = 'Expired';
        update existingContract;
        return existingContract.Id;
    }*/
}