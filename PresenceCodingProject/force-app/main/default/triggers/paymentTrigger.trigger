/*************************************************************************************************
Apex Trigger Name : paymentTrigger
Version : 
Created Date : 
Function :  

Modification Log:
-------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                            	Date                            		Description
* -----------------------------------------------------------------------------------------------------------------------------------------------
* Juan Gallegos							06/14/2021			          			initial version 
*************************************************************************************************/
trigger paymentTrigger on Payment__c (after insert,after update,after delete) {
    paymentTriggerHandler handler = new paymentTriggerHandler();
    
      
    if(trigger.isInsert && trigger.isAfter){
        handler.onAfterInsert(Trigger.New);
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        handler.onAfterUpdate(Trigger.New);
    }
    
    if(trigger.isDelete && trigger.isAfter){
        handler.onAfterDelete(Trigger.old);
    }
    
}