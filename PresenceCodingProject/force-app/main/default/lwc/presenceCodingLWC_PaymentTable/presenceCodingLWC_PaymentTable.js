import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';
import getAccountList from '@salesforce/apex/ClsPaymentTriggerHandler.getPayments';


export default class presenceCodingLWC_PaymentTable extends LightningElement {
  
    payments;
    error;

    /** Wired Apex result so it can be refreshed programmatically */
    wiredPaymentsResult;

    @wire(getAccountList)
    wiredPayments(result) {
        this.wiredPaymentsResult = result;
        if (result.data) {
            this.payments = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.payments = undefined;
        }
    }

    deletePayment(event) {
        const recordId = event.target.dataset.recordid;
        deleteRecord(recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Payment deleted',
                        variant: 'success'
                    })
                );
                return refreshApex(this.wiredPaymentsResult);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
            });
    }
}