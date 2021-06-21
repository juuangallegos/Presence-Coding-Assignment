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
        setUpProjectInfo(projectList,false);
        setUpContactInfo(contactList,newPayments[0].Payment_Date__c,false);
    }
    
    public void OnAfterUpdatePayments(List<Payment__c> newPayments) {        
        
        for(Payment__c payment : newPayments){
            projectId.add(payment.Project__c);
            contactId.add(payment.Contact__c);
        }
        projectList = getProjectInfo(projectId);
        contactList = getContactInfo(contactId);
        setUpProjectInfo(projectList,false);
        setUpContactInfo(contactList,newPayments[0].Payment_Date__c,false);
    }
    
    public void OnAfterDeletePayments(List<Payment__c> newPayments) {        
        for(Payment__c payment : newPayments){
            projectId.add(payment.Project__c);
            contactId.add(payment.Contact__c);
        }
        projectList = getProjectInfo(projectId);
        contactList = getContactInfo(contactId);
        setUpProjectInfo(projectList,true);
        setUpContactInfo(contactList,newPayments[0].Payment_Date__c,true);
    }
    
    public List<Contact> getContactInfo(Set<Id> contactIds){
        contactList = [SELECT Id,Total_Amount_Payment__c,Recent_Payment_Date__c FROM Contact WHERE Id =:contactIds];
        return contactList;
    }
    
    public List<Project__c> getProjectInfo(Set<Id> projectIds){
        projectList = [SELECT Id,Amount_Payment__c FROM Project__c WHERE Id =:projectIds];
        return projectList;
    }
    public void setUpProjectInfo(List<Project__c> projectList,Boolean isDelete){
        for(Project__c pr:projectList){
            if(!projectList.isEmpty()){
                if(pr.Amount_Payment__c != null && isDelete){
                    pr.Amount_Payment__c = pr.Amount_Payment__c - 1;
                }else{
                    pr.Amount_Payment__c = pr.Amount_Payment__c + 1;
                }
            } 
        }
        update projectList;
    }
    
    public void setUpContactInfo(List<Contact> contactList, Date paymentDate, Boolean isDelete){
        for(Contact co: contactList){
            if(!contactList.isEmpty()){
                if(co.Total_Amount_Payment__c != null && isDelete){
                    co.Total_Amount_Payment__c = co.Total_Amount_Payment__c - 1;
                    co.Recent_Payment_Date__c = paymentDate;
                }else{
                    co.Total_Amount_Payment__c = co.Total_Amount_Payment__c + 1;
                    co.Recent_Payment_Date__c = paymentDate;  
                }  
            } 
        }
        update contactList;
    }

    @AuraEnabled(cacheable=true)
    public static void deletePayments(String paymentId){
        List<Payment__c> paymentList = [SELECT Id,Payment_Date__c FROM Payment__c WHERE Id =: paymentId ];
        if(!paymentList.isEmpty()){
            delete paymentList;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        return [SELECT Id, FirstName,LastName,Total_Amount_Payment__c,Recent_Payment_Date__c FROM Contact WHERE Total_Amount_Payment__c >0];
    }

    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getPayments(){
        return [SELECT Id, Payment_Date__c,Contact__r.FirstName, Contact__r.LastName,Amount__c FROM Payment__c];
    }

    @AuraEnabled
    public static Payment__c createPayment(Payment__c pa){
      insert pa;
      return pa;
    }
}