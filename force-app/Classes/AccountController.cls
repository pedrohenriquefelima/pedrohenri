public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, Website FROM Account ORDER BY name ASC LIMIT 5];
    }
}
