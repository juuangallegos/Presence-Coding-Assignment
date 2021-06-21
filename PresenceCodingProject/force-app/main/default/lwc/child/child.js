import { LightningElement, wire, track ,api} from 'lwc';
import getPaymentList from '@salesforce/apex/ClsPaymentTriggerHandler.getPayments';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { deleteRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import PAYMENT_DATE  from '@salesforce/schema/Payment__c.Payment_Date__c';
import AMOUNT  from '@salesforce/schema/Payment__c.Amount__c';
import ID from '@salesforce/schema/Payment__c.Id';

const actions = [
    { label: 'Delete', name: 'delete' }
];

const COLS = [
    { label: 'Amount', fieldName: 'Amount__c',editable: true },
    { label: 'Payment Date', fieldName: 'Payment_Date__c',editable: true},
    { type:'action',typeAttributes: { rowActions: actions, menuAlignment: 'right' } }
];

export default class presenceCodingLWC_PaymentTable extends LightningElement {
  
    @api recordId;
    @track columns = COLS;
    @track error;
    draftValues = [];


    @wire(getPaymentList)
    wiredPaymentsResult;  
    

    handleSavePayments(event) {
        console.log('###save payment')
        let fields = {}; 
        fields[ID.fieldApiName] = event.detail.draftValues[0].Id;
        fields[AMOUNT.fieldApiName] = event.detail.draftValues[0].Amount__c;
        fields[PAYMENT_DATE.fieldApiName] = event.detail.draftValues[0].Payment_Date__c;
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
            
            const selectEvent=new CustomEvent('myscustomevent',{detail:name,bubbles:true});
             this.dispatchEvent(selectEvent);
            return refreshApex(this.wiredPaymentsResult).then(() => {

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

    refreshContactTable(){
        const selectEvent=new CustomEvent('myscustomevent',{detail:name,bubbles:true});
        this.dispatchEvent(selectEvent);
        setTimeout(() => {
            this.template.querySelectorAll('lightning-input-field').forEach(element => {
                element.value = null;
            });
          
        },1800);

        setTimeout(() => {
            return refreshApex(this.wiredPaymentsResult);
          
        },1800);

      
    }  

    handleRowAction(event) {
        
        const action = event.detail.action;
        const row = event.detail.row;
        const id = row.Id;
    
        deleteRecord(id)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record deleted',
                    variant: 'success'
                })
            );
          
            setTimeout(() => {
                const selectEvent=new CustomEvent('myscustomevent',{detail:name,bubbles:true});
                this.dispatchEvent(selectEvent);
                return refreshApex(this.wiredPaymentsResult);
            }, 1800);
     
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error deleting record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
}
}