import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import FAX_FIELD from '@salesforce/schema/Contact.Fax';


export default class CreateContact extends NavigationMixin(LightningElement) {

    @api objectApiName = "Contact";
    @track id = " ";

    fields = [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD, FAX_FIELD];

    handleSuccess(event) {
        this.recordId = event.detail.id;
        const evt = new ShowToastEvent({
            title: "Contact created",
            message: "Record ID: " + this.recordId,
            variant: "success"
        });
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Contact', // objectApiName is optional
                actionName: 'view'
            }
        });
        this.dispatchEvent(evt);
    }

}
