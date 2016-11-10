/**
 * Created by viktor on 07.11.16.
 */

public with sharing class Test1Contacts{

    @AuraEnabled
    public static List<Account> sFindAccountByName(String searchKey) {
        if ( String.isEmpty(searchKey)) return new List<Account>();
        if ( searchKey.length() < 3 ) return new List<Account>();
        String name = '%' + searchKey + '%';
        return [SELECT Id, Name FROM Account LIMIT 50];
        //return [SELECT Id, Name FROM Account WHERE Name LIKE :name LIMIT 50];
    }

    @AuraEnabled
    public static List<Contact> sFindContactsByAccountId(String accountId) {
        if ( String.isEmpty(accountId)) return new List<Contact>();

        return [SELECT Id, Name, Phone, MobilePhone,  Email
            FROM Contact WHERE AccountId = :accountId];
    } // TODO , MailingAddress, OtherAddress

    public static String serializeAddress(Address adr) {
        if ( adr == null ) return '';
        String ret = adr.city;


        return ret;
    }
}