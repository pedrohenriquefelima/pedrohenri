global class sendEmailAttachmentsOver {
    @InvocableMethod
    global static void download(List<String> recorsdId){
        
        List<ContentDocumentLink> files = new List<ContentDocumentLink>();
        // new instance of the SingleEmailMessag
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //query for custom metadata
        List<String> proTeamAddresses = new List<String>();

        for (Product_Dev_Team_Email_Address__mdt threatMapping : [SELECT Email_Address__c FROM Product_Dev_Team_Email_Address__mdt]) {
            if(!String.isBlank(threatMapping.Email_Address__c)){
                proTeamAddresses.add(threatMapping.Email_Address__c);
            }
        }

        //recipient's email address
        message.setToAddresses(proTeamAddresses);

        // required information from the object’s attachments
            files = [SELECT ContentDocumentId, ContentDocument.latestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :recorsdId];
            List<Id> latestPubVersionAttachmentId = new List<Id>();
            for(ContentDocumentLink cdl : files){
                latestPubVersionAttachmentId.add(cdl.ContentDocument.latestPublishedVersionId);
            }
       
        if(latestPubVersionAttachmentId.size() > 0){
            message.setEntityAttachments(latestPubVersionAttachmentId);
        }
        
        case caseFields = [SELECT CaseNumber,Account.Name, Account.Owner.Email, CreatedDate,Region__c,Contact.Name,Product_Type__c,Description,Project_Type__c,High_Level_Requirements__c,Number_of_Users_roughly__c,Estimated_Price_of_Project__c,End_Date__c,General_Notes__c,Key_Milestones__c,Integration_Method__c,CurrencyIsoCode,Contact_Email__c,Contact_Title__c FROM Case WHERE Id = :recorsdId[0]];
        String ownerAddress = caseFields.Account.Owner.Email;
       
        
        String subject = 'New Custom Skeleton Proposal';
        String bodyMessage = '<h1> Custom Skeleton Proposal</h1>';
        bodyMessage = bodyMessage + '<Strong> Case Number: <Strong> ' + caseFields.CaseNumber + '<br>';
        bodyMessage = bodyMessage + '<Strong> Date Created: <Strong> ' +  caseFields.CreatedDate.format()+ '<br>';
        bodyMessage = bodyMessage + '<h2>Account Information</h2>';
        bodyMessage = bodyMessage + '<Strong> Account Name: <Strong> ' + caseFields.Account.Name + '</br>';
       
        If(!String.isBlank(String.valueOf(caseFields.End_Date__c))){
            bodyMessage = bodyMessage + '<Strong> Project Closure Date: <Strong> ' + caseFields.End_Date__c.format()+ '<br>';
        }
        bodyMessage = bodyMessage + '<Strong>Key Milestones: <Strong> ' + caseFields.Key_Milestones__c + '</br><br>';
      
        message.setSubject(subject);
        message.setHtmlBody(bodyMessage);
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
          } catch (Exception e) {
            throw e;
          }
    }
}
