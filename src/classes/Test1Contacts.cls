/**
 * Created by viktor on 07.11.16.
 */

public with sharing class Test1Contacts{

    @AuraEnabled
    public static List<Account> findAccountByName(String searchKey) {
        // TODO check searchKey length > 3
        String name = '%' + searchKey + '%';
        return [SELECT Id, Name FROM Account WHERE Name LIKE :name LIMIT 50];
    }

    @AuraEnabled
    public static List<Contact> findContactsByAccountId(String accountId) {
        // FIXME check for empty
        return [SELECT Id, Name, Phone, MobilePhone,  Email, MailingAddress, OtherAddress
        FROM Contact WHERE AccountId = :accountId];
    }
}