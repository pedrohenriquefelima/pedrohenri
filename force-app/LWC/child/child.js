import { LightningElement, api } from 'lwc';

export default class Child extends LightningElement {
    @api account;
    //child to parent
    communicateEventToParent(event){
        //receivedFromChild named given to event that needs to be called from parent
        const selectedEvent = new CustomEvent('sendtoparent', {detail: this.account});
        this.dispatchEvent(selectedEvent);
    }
}