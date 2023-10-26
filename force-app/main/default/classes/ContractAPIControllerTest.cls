@isTest
private class ContractAPIControllerTest {

    // Méthode de test pour la création d'un contrat
    @isTest static void testCreateContract() {
        Test.startTest();

        // Création d'un compte et d'un contact pour le test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName='Test', LastName='Contact', AccountId=testAccount.Id);
        insert testContact;

        // Préparation de la requête
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Contract/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(
            new Map<String, Object>{
                'ContactId' => testContact.Id,
                'StartDate' => '2023-11-01',
                'ContractTerm' => '12',
                'Status' => 'Draft'
            }
        ));
        
        RestContext.request = req;
        RestContext.response = res;

        // Appel de la méthode
        String contractId = ContractAPIController.createContract();

        Test.stopTest();

        // Vérification des résultats
        System.assertNotEquals(null, contractId, 'Contract should be created');
        Contract createdContract = [SELECT Id, AccountId, StartDate, ContractTerm, Status FROM Contract WHERE Id = :contractId];
        System.assertEquals(testAccount.Id, createdContract.AccountId, 'Account ID should match');
        System.assertEquals(Date.parse('2023-11-01'), createdContract.StartDate, 'Start Date should match');
        System.assertEquals(12, createdContract.ContractTerm, 'Contract Term should match');
        System.assertEquals('Draft', createdContract.Status, 'Status should match');
    }


    @isTest
    static void testCreateContract_NoAccount() {
        // Créez un contact sans AccountId
        Contact cont = new Contact(LastName = 'Test Contact');
        insert cont;
        
        // Préparez la requête et l'appel à l'API
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{"ContactId":"' + cont.Id + '", "StartDate":"2023-11-01", "ContractTerm":"12", "Status":"Draft"}');
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String contractId = ContractAPIController.createContract();
        Test.stopTest();
        
        // Vérifiez que le contrat a été créé et que les données sont correctes
        Contract createdContract = [SELECT Id, AccountId, StartDate, ContractTerm, Status FROM Contract WHERE Id = :contractId];
        System.assertNotEquals(null, createdContract.AccountId);
        System.assertEquals(Date.valueOf('2023-11-01'), createdContract.StartDate);
        System.assertEquals(12, createdContract.ContractTerm);
        System.assertEquals('Draft', createdContract.Status);
    }

    // Méthode de test pour la mise à jour d'un contrat
    
        @isTest
    static void testUpdateContract() {
        // Crée un compte, un contact et un contrat pour la mise à jour
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
        insert testContact;

        Contract testContract = new Contract(AccountId = testAccount.Id, StartDate = Date.today(), ContractTerm = 12, Status = 'Draft');
        insert testContract;

        // Prépare la requête et l'appel à l'API
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{"ContractId":"' + testContract.Id + '", "StartDate":"2023-11-01", "ContractTerm":"6"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String contractId = ContractAPIController.updateContract();
        Test.stopTest();

        // Vérifie que le contrat a été mis à jour
        Contract updatedContract = [SELECT Id, StartDate, ContractTerm FROM Contract WHERE Id = :contractId];
        System.assertEquals(Date.valueOf('2023-11-01'), updatedContract.StartDate);
        System.assertEquals(6, updatedContract.ContractTerm);
    }

}
