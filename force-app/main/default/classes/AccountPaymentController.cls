public with sharing class AccountPaymentController {

    // Method to get a list of all Accounts
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        // Bring the accounts ordered by Name
        return [SELECT Id, Name FROM Account ORDER BY Name ASC];
    }

    // Method to get Payments related to a specific Account Id
    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getPaymentsByAccountId(String accountId) {
        if (String.isBlank(accountId)) {
            return new List<Payment__c>();
        }
        return [
            SELECT 
                Id, 
                Name, 
                Amount__c, 
                Due_Date__c, 
                Payment_Type__c, 
                Notes__c, 
                Account__c 
            FROM 
                Payment__c 
            WHERE 
                Account__c = :accountId 
            ORDER BY 
                Due_Date__c DESC
        ];
    }

    // Method to create a new Payment record
    @AuraEnabled
    public static Id createPayment(Payment__c newPayment) {
        if (newPayment == null) {
            throw new AuraHandledException('Payment record cannot be null.');
        }

        try {
            insert newPayment;
            return newPayment.Id;
        } catch (DmlException e) {
            // Catch DML error
            // Sends the details of the error to LWC.
            String errorMessage = 'Error creating Payment: ' + e.getDmlMessage(0);
            throw new AuraHandledException(errorMessage);
        }
    }
}