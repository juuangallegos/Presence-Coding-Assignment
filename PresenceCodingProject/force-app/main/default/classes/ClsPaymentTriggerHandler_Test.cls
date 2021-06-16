/*************************************************************************************************
Apex Class Name : ClsPaymentTriggerHandler_Test
Version : 
Created Date : 
Function :  

Modification Log:
-------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                            	Date                            		Description
* -----------------------------------------------------------------------------------------------------------------------------------------------
* Juan Gallegos							06/14/2021			          			initial version 
*************************************************************************************************/
@isTest
public class ClsPaymentTriggerHandler_Test {
    @TestSetup
    private static void init() {
        
        Account a1 = new Account();
        a1.Name = 'Acc1';
        insert a1;
        
        Contact c1 = new Contact();
        c1.LastName = 'Cont1';
        c1.AccountId = a1.Id;
        insert c1;
        
        Project__c pro1 =  new Project__c();
        insert pro1;
        
        Payment__c pay1 = new Payment__c();
        pay1.Project__c = pro1.id;
        pay1.Contact__c = c1.id;
        pay1.Payment_Date__c = System.today();
        insert pay1;
        Payment__c pay2 = new Payment__c();
        pay2.Project__c = pro1.id;
        pay2.Contact__c = c1.id;
        pay2.Payment_Date__c = System.today()+4;
        insert pay2;
    }
    
    public static testMethod void paymentFlow() {
        Test.startTest();
        ClsPaymentTriggerHandler handlerClass = new ClsPaymentTriggerHandler();
        List<Payment__c> paymentObj = [SELECT Id,Project__c,Contact__c,Payment_Date__c FROM Payment__c];
        handlerClass.OnAfterInsertPayments(paymentObj);
        handlerClass.OnAfterUpdatePayments(paymentObj);
        handlerClass.OnAfterDeletePayments(paymentObj);
        Test.stopTest();
    }
}