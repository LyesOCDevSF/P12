@IsTest
global class ContractAPIControllerTest {

    // Teste la méthode createContract de la classe ContractAPIController.
    @IsTest
    static void testCreateContract() {
        // Crée un compte pour le contrat.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Prépare la requête et la réponse.
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestBody = Blob.valueOf(JSON.serialize(new Map<String, String> {
            'AccountId' => testAccount.Id,
            'StartDate' => '2023-11-01',
            'ContractTerm' => '12'
        }));
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        // Appelle la méthode createContract et vérifie le résultat.
        String contractId = ContractAPIController.createContract();
        Contract createdContract = [SELECT Id, AccountId, StartDate, ContractTerm FROM Contract WHERE Id = :contractId];
        Test.stopTest();
        System.assertEquals(testAccount.Id, createdContract.AccountId);
        System.assertEquals(Date.parse('2023-11-01'), createdContract.StartDate);
        System.assertEquals(12, createdContract.ContractTerm);
        
        
    }

    // Teste la méthode updateContract de la classe ContractAPIController.
    @IsTest
    static void testUpdateContract() {
        // Crée un compte et un contrat pour le test.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            StartDate = Date.today(),
            ContractTerm = 12
        );
        insert testContract;

        // Prépare la requête et la réponse.
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestBody = Blob.valueOf(JSON.serialize(new Map<String, String> {
            'ContractId' => testContract.Id,
            'StartDate' => '2023-11-01',
            'ContractTerm' => '24'
        }));
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        // Appelle la méthode updateContract et vérifie le résultat.
        String contractId = ContractAPIController.updateContract();
        Contract updatedContract = [SELECT Id, StartDate, ContractTerm FROM Contract WHERE Id = :contractId];
        Test.stopTest();
        System.assertEquals(Date.parse('2023-11-01'), updatedContract.StartDate);
        System.assertEquals(24, updatedContract.ContractTerm);
        
        
    }

    // Teste la méthode deactivateContract de la classe ContractAPIController.
    @IsTest
    static void testDeactivateContract() {
        // Crée un compte et un contrat pour le test.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            StartDate = Date.today(),
            ContractTerm = 12,
            Status = 'Activated'
        );
        insert testContract;

        // Prépare la requête et la réponse.
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/Contract/' + testContract.Id;
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        // Appelle la méthode deactivateContract et vérifie le résultat.
        String contractId = ContractAPIController.deactivateContract();
        Contract deactivatedContract = [SELECT Id, Status FROM Contract WHERE Id = :contractId];
        Test.stopTest();
        System.assertEquals('Expired', deactivatedContract.Status);
        
        
    }
}
