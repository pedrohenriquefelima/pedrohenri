import { LightningElement, wire, track } from 'lwc';
import {subscribe, MessageContext} from 'lightning/messageService';
import MY_FIRST_MESSAGE_CHANNEL from '@salesforce/messageChannel/myFirstMessageChannel__c';
export default class Cousin extends LightningElement {

    mySubscription = null;
    @track fakeAccount = {accountName:"", website:""};
    @wire(MessageContext)
    myReceiverMessageContext;

    subscriptionFunction(){
        this.mySubscription = subscribe(this.myReceiverMessageContext,
                                        MY_FIRST_MESSAGE_CHANNEL,
                                        (message) => this.handleMessage(message));
    }
    connectedCallback(){
        this.subscriptionFunction();
    }
    handleMessage(message){
        this.fakeAccount.accountName = message.accountName;
        this.fakeAccount.website = message.website;
        console.log("handle Message: " + this.fakeAccount.accountName);
        console.log("handle Message: " + this.fakeAccount.website);
    }
}