/*************************************************************************************************
Apex Class Name : ClsPaymentTriggerHandler
Version : 
Created Date : 
Function :  

Modification Log:
-------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                            	Date                            		Description
* -----------------------------------------------------------------------------------------------------------------------------------------------
* Juan Gallegos							06/14/2021			          			initial version 
*************************************************************************************************/
public class ClsPaymentTriggerHandler {
    
    Set<Id> paymentId = new Set<Id>();
    Set<Id> projectId = new Set<Id>();
    Set<Id> contactId = new Set<Id>();
    List<Project__c> projectList = new List<Project__c>();
    List<Contact> contactList = new List<Contact>();
    
    
    public void OnAfterInsertPayments(List<Payment__c> newPayments) {
        for(Payment__c payment : newPayments){
            projectId.add(payment.Project__c);
            contactId.add(payment.Contact__c);
        }
        projectList = getProjectInfo(projectId);
        contactList = getContactInfo(contactId);
        
        for(Project__c pr:projectList){
            if(!projectList.isEmpty() && pr.Amount_Payment__c != null){
                pr.Amount_Payment__c = pr.Amount_Payment__c + 1;
            }            
        }
        for(Contact co: contactList){
            if(!contactList.isEmpty() && co.Total_Amount_Payment__c != null){
                co.Total_Amount_Payment__c = co.Total_Amount_Payment__c + 1;
                co.Recent_Payment_Date__c = System.today();
            }
        }
        update projectList;
        update contactList; 
        
    }
    
    public void OnAfterUpdatePayments(List<Payment__c> newPayments) {        
        
        for(Payment__c payment : newPayments){
            projectId.add(payment.Project__c);
            contactId.add(payment.Contact__c);
        }
        projectList = getProjectInfo(projectId);
        contactList = getContactInfo(contactId);
        
        for(Project__c pr:projectList){
            if(!projectList.isEmpty() && pr.Amount_Payment__c != null){
                pr.Amount_Payment__c = pr.Amount_Payment__c + 1;
            }            
        }
        for(Contact co: contactList){
            if(!contactList.isEmpty() && co.Total_Amount_Payment__c != null){
                co.Total_Amount_Payment__c = co.Total_Amount_Payment__c + 1;
                co.Recent_Payment_Date__c = System.today();
            }
        }
        update projectList;
        update contactList; 
        
    }
    
    public void OnAfterDeletePayments(List<Payment__c> newPayments) {        
        
        for(Payment__c payment : newPayments){
            projectId.add(payment.Project__c);
            contactId.add(payment.Contact__c);
        }
        projectList = getProjectInfo(projectId);
        contactList = getContactInfo(contactId);
        
        for(Project__c pr:projectList){
            if(!projectList.isEmpty() && pr.Amount_Payment__c != null){
                pr.Amount_Payment__c = pr.Amount_Payment__c - 1;
            }            
        }
        for(Contact co: contactList){
            if(!contactList.isEmpty() && co.Total_Amount_Payment__c != null){
                co.Total_Amount_Payment__c = co.Total_Amount_Payment__c - 1;
                co.Recent_Payment_Date__c = System.today();
            }
        }
        update projectList;
        update contactList; 
        
    }
    
    public List<Contact> getContactInfo(Set<Id> contactIds){
        contactList = [SELECT Id,Total_Amount_Payment__c,Recent_Payment_Date__c FROM Contact WHERE Id =:contactIds];
        return contactList;
    }
    
    public List<Project__c> getProjectInfo(Set<Id> projectIds){
        projectList = [SELECT Id,Amount_Payment__c FROM Project__c WHERE Id =:projectIds];
        return projectList;
    }
}