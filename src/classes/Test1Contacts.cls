/**
 * Created by viktor on 07.11.16.
 */

public with sharing class Test1Contacts{

    @AuraEnabled
    public static List<Contact> findContactByName(String searchKey, Integer itemsPerPage) {
/*        if ( String.isEmpty(searchKey)) {
            return new List<Contact>();
        }
        if ( searchKey.length() < 3 ) {
            return new List<Contact>();
        }*/
        itemsPerPage = Integer.valueOf(itemsPerPage);
        itemsPerPage = itemsPerPage > 0 ? itemsPerPage : 10;
                String name = '%' + searchKey + '%';
        return [SELECT Id, Name, Phone, MobilePhone,  Email FROM Contact WHERE AccountId != null LIMIT : itemsPerPage];
        //return [SELECT Id, Name, Phone, MobilePhone, Email FROM Contact WHERE AccountId != null AND Name LIKE :name LIMIT : itemsPerPage];
    } // TODO , MailingAddress, OtherAddress

    public static String serializeAddress(Address adr) {
        if ( adr == null ) return '';
        String ret = adr.city;


        return ret;
    }
}