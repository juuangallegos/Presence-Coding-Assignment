/*************************************************************************************************
Apex Class Name : paymentTriggerHandler
Version : 
Created Date : 
Function :  

Modification Log:
-------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                            	Date                            		Description
* -----------------------------------------------------------------------------------------------------------------------------------------------
* Juan Gallegos							06/14/2021			          			initial version 
*************************************************************************************************/
public class paymentTriggerHandler {
    ClsPaymentTriggerHandler paymentHandler = new ClsPaymentTriggerHandler();    
    List<Payment__c> lstNewPayments = new List<Payment__c>();
    List<Payment__c> lstUptPayments = new List<Payment__c>();
    List<Payment__c> lstDelPayments = new List<Payment__c>();
    
    public void onAfterInsert(List<Payment__c> paymentInserted) {
        
        for(Payment__c paymt : paymentInserted) {
            lstNewPayments.add(paymt);
        }
        if(!lstNewPayments.isEmpty()) {
            paymentHandler.OnAfterInsertPayments(lstNewPayments);
        }        
    }
    
    public void onAfterUpdate(Payment__c[] paymentUpdated) {
        
        for(Payment__c paymt : paymentUpdated) {
            lstUptPayments.add(paymt);
        }
        if(!lstUptPayments.isEmpty()) {
            paymentHandler.OnAfterUpdatePayments(lstUptPayments);
        }
    }
    
    public void onAfterDelete(Payment__c[] paymentToDelete) {
        
        for(Payment__c paymt : paymentToDelete) {
            lstDelPayments.add(paymt);
        }
        if(!lstDelPayments.isEmpty()) {
            paymentHandler.OnAfterDeletePayments(lstDelPayments);
        }
    }
    
    
    
}