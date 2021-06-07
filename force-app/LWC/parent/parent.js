import { LightningElement, wire, track} from 'lwc';
import {publish, MessageContext} from 'lightning/messageService';
import MY_FIRST_MESSAGE_CHANNEL from '@salesforce/messageChannel/myFirstMessageChannel__c';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
export default class Parent extends LightningElement {
    elementFromChild;
    @track list;

    @wire(getAccounts)
    wireGetAccount({error, data}) {
        if (data) {
            console.log('DDDD ' + JSON.stringify(data));
            this.list = data;
        } else if (error) {
            console.log('EER ' + JSON.stringify(error));
        } 
    }

    @wire(MessageContext)
    myMessageContext;

    sendtosibling(event){
        console.log('AAA ' + JSON.stringify(event.detail));
        this.elementFromChild = event.detail;
        let payload = {accountName: event.detail.Name, website: event.detail.Website};
        publish(this.myMessageContext,MY_FIRST_MESSAGE_CHANNEL,payload);
    }
}