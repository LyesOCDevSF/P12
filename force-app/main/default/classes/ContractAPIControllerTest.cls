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
                'StartDate' => '2023-01-01',
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
        System.assertEquals(Date.parse('2023-01-01'), createdContract.StartDate, 'Start Date should match');
        System.assertEquals(12, createdContract.ContractTerm, 'Contract Term should match');
        System.assertEquals('Draft', createdContract.Status, 'Status should match');
    }

    // Méthode de test pour la mise à jour d'un contrat
    @isTest static void testUpdateContract() {
        Test.startTest();

        // Création d'un compte, d'un contact et d'un contrat pour le test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName='Test', LastName='Contact', AccountId=testAccount.Id);
        insert testContact;

        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            StartDate = Date.parse('2023-01-01'),
            ContractTerm = 12,
            Status = 'Draft'
        );
        insert testContract;

        // Préparation de la requête
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Contract/';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(JSON.serialize(
            new Map<String, Object>{
                'ContractId' => testContract.Id,
                'StartDate' => '2023-02-01',
                'ContractTerm' => '6'
            }
        ));
        
        RestContext.request = req;
        RestContext.response = res;

        // Appel de la méthode
        String contractId = ContractAPIController.updateContract();

        Test.stopTest();

        // Vérification des résultats
        System.assertEquals(testContract.Id, contractId, 'Contract ID should match');
        Contract updatedContract = [SELECT Id, StartDate, ContractTerm FROM Contract WHERE Id = :contractId];
        System.assertEquals(Date.parse('2023-02-01'), updatedContract.StartDate, 'Start Date should be updated');
        System.assertEquals(6, updatedContract.ContractTerm, 'Contract Term should be updated');
    }
}
