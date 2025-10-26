@IsTest
private class AccountPaymentController_Test {

    @TestSetup
    static void setupTestData() {
        // Creata test Account
        Account acc = new Account(Name = 'Test Account for Payments');
        insert acc; 

        //  Create test Payments related to the Account
        List<Payment__c> payments = new List<Payment__c>();

        // Payment 1: Test data for successful scenario
        payments.add(new Payment__c(
            Name = 'PMT-001', 
            Account__c = acc.Id,
            Amount__c = 100.00,
            Payment_Type__c = 'Service', 
            Due_Date__c = Date.today().addDays(7), // For passing validation rule, future date
            Notes__c = 'Test Service Payment'
        ));

        // Payment 2: Test data for successful scenario
        payments.add(new Payment__c(
            Name = 'PMT-002', 
            Account__c = acc.Id,
            Amount__c = 250.50,
            Payment_Type__c = 'Product',
            Due_Date__c = Date.today().addDays(14)
        ));

    
        insert payments; 
    }

    @IsTest
    static void testGetAccounts() {
        Test.startTest();
        List<Account> accounts = AccountPaymentController.getAccounts();
        Test.stopTest();
        System.assertNotEquals(0, accounts.size(), 'En az bir hesap döndürmelidir.');
    }

    @IsTest
    static void testGetPaymentsByAccountId() {
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account for Payments' LIMIT 1];

        Test.startTest();
        List<Payment__c> payments = AccountPaymentController.getPaymentsByAccountId(testAcc.Id);
        List<Payment__c> emptyPayments = AccountPaymentController.getPaymentsByAccountId(null);
        Test.stopTest();

        System.assertEquals(2, payments.size(), 'Setup başarılıysa 2 ödeme kaydı dönmelidir.');
        System.assertEquals(0, emptyPayments.size(), 'Account Id boşken boş liste dönmelidir.');
    }

    @IsTest
    static void testCreatePayment_Success() {
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account for Payments' LIMIT 1];
        
        Payment__c newPayment = new Payment__c(
            Name = 'PMT-TEST-SUCCESS',
            Account__c = testAcc.Id,
            Amount__c = 50.00,
            Payment_Type__c = 'Other',
            Due_Date__c = Date.today().addMonths(1)
        );

        Test.startTest();
        Id paymentId = AccountPaymentController.createPayment(newPayment);
        Test.stopTest();

        System.assertNotEquals(null, paymentId, 'Başarılı oluşturmada Id dönmelidir.');
    }

    @IsTest
    static void testCreatePayment_DmlException_ValidationRule() {
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account for Payments' LIMIT 1];
        
       
        Payment__c invalidPayment = new Payment__c(
            Name = 'PMT-TEST-FAIL',
            Account__c = testAcc.Id,
            Amount__c = 99.99,
            Payment_Type__c = 'Product',
            Due_Date__c = Date.today() // Error: Due Date must be in the future
        );

        Boolean caughtException = false;
        Test.startTest();
        try {
            AccountPaymentController.createPayment(invalidPayment);
        } catch (AuraHandledException e) {
            caughtException = true;
            System.assert(e.getMessage().contains('Hata oluştu:'), 'DML hatası yakalanmalıdır.');
        }
        Test.stopTest();
        System.assert(caughtException, 'DML hatası yakalanmalıdır.');
    }
}