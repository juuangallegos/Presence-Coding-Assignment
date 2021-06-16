import { LightningElement,track, wire, api } from 'lwc';
import getContacts from '@salesforce/apex/ClsPaymentTriggerHandler.getContacts';
import getPayments from '@salesforce/apex/ClsPaymentTriggerHandler.getPayments';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import MOST_RECENT_PAYMENT_FIELD  from '@salesforce/schema/Contact.Recent_Payment_Date__c';
import TOTAL_AMOUNT  from '@salesforce/schema/Contact.Total_Amount_Payment__c';
import ID_FIELD from '@salesforce/schema/Contact.Id';


const COLS = [
    { label: 'First Name', fieldName: 'FirstName', editable: true },
    { label: 'Last Name', fieldName: 'LastName', editable: true },
    { label: 'Total Amount', fieldName: 'Total_Amount_Payment__c',editable: true },
    { label: 'Most Recent Payment', fieldName: 'Recent_Payment_Date__c',editable: true}
];


export default class presenceCodingLWC extends LightningElement {

    @api recordId;
    columns = COLS;
    draftValues = [];

    @wire(getContacts)
    contact;

    handleSaveContacts(event) {

        const fields = {}; 
        fields[ID_FIELD.fieldApiName] = event.detail.draftValues[0].Id;
        fields[FIRSTNAME_FIELD.fieldApiName] = event.detail.draftValues[0].FirstName;
        fields[LASTNAME_FIELD.fieldApiName] = event.detail.draftValues[0].LastName;
        fields[TOTAL_AMOUNT.fieldApiName] = event.detail.draftValues[0].Total_Amount_Payment__c;
        fields[MOST_RECENT_PAYMENT_FIELD.fieldApiName] = event.detail.draftValues[0].Recent_Payment_Date__c;
        const recordInput = {fields};

        updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact updated',
                    variant: 'success'
                })
            );
            return refreshApex(this.contact).then(() => {

                this.draftValues = [];

            });
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

   
}