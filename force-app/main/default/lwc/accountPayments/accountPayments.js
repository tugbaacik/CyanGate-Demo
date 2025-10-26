import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

// Apex methods
import getAccounts from '@salesforce/apex/AccountPaymentController.getAccounts';
import getPaymentsByAccountId from '@salesforce/apex/AccountPaymentController.getPaymentsByAccountId';

// Data table columns
const ACCOUNT_COLS = [
    { label: 'Account Name', fieldName: 'Name', type: 'text' }
];
const PAYMENT_COLS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Amount', fieldName: 'Amount__c', type: 'currency' },
    { label: 'Type', fieldName: 'Payment_Type__c', type: 'text' },
    { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date', typeAttributes: { year: 'numeric', month: 'short', day: 'numeric' } }
];

export default class AccountPayments extends LightningElement {
    @track accounts = [];
    accountColumns = ACCOUNT_COLS;
    @track payments = [];
    paymentColumns = PAYMENT_COLS;
    
    @track selectedAccountId = null;
    @track selectedAccountName = '';
    
    wiredAccountsResult; 
    @wire(getAccounts)
    wiredAccounts(result) {
        this.wiredAccountsResult = result;
        if (result.data) {
            this.accounts = result.data;
        } else if (result.error) {
            this.handleError(result.error, 'Error Loading Accounts');
        }
    }

    wiredPaymentsResult; 
    @wire(getPaymentsByAccountId, { accountId: '$selectedAccountId' })
    wiredPayments(result) {
        this.wiredPaymentsResult = result;
        if (result.data) {
            this.payments = result.data;
        } else if (result.error) {
            this.payments = [];
            this.handleError(result.error, 'Error Loading Payments');
        }
    }

    // Account selection handler
    handleAccountSelection(event) {
        const selectedRows = event.detail.selectedRows;
        
        let newAccountId = null;
        let newAccountName = '';

        console.log('--- Row Selection ---');

        if (selectedRows && selectedRows.length > 0) {
            const selectedAccount = selectedRows[0];
            
            newAccountId = selectedAccount.Id;
            newAccountName = selectedAccount.Name;
            
            console.log('Newly Selected Account ID:', newAccountId); 
        } 
        
        
        this.selectedAccountId = undefined; 
        
        
        this.selectedAccountId = newAccountId;
        this.selectedAccountName = newAccountName;
       
    }

    // Payment record success handler
    handlePaymentSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Payment record created.',
                variant: 'success'
            })
        );
        refreshApex(this.wiredPaymentsResult);
        this.template.querySelector('lightning-record-edit-form').reset();
    }
    
    // Error handler
    handleError(error, title) {
        console.error(error);
        const errorMessage = error.body ? error.body.message : 'Unknown Error';
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: errorMessage,
                variant: 'error',
                mode: 'sticky'
            })
        );
    }
    
    // Form error handler
    handlePaymentError(event) {
        let message = 'An unknown error occurred.';
        if (event.detail && event.detail.detail) {
            message = event.detail.detail; 
        } else if (event.detail && event.detail.message) {
             message = event.detail.message;
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error Creating Payment',
                message: message,
                variant: 'error',
                mode: 'sticky'
            })
        );
    }
}