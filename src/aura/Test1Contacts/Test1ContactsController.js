/**
 * Created by viktor on 07.11.16.
 */
({
    searchContacts : function (component, event, helper) {
        console.log(event);
        console.log(component.isValid());
        console.log('search account: '); // + event.getName())
        var sq = component.get('v.searchQuery');
        console.log(sq);
        helper.searchContacts(component, sq, helper);
        if ( $A.util.isEmpty(sq) ) {
            return;
        }
        if ( sq.length < 3 ) { // TODO make cache
            return;
        }
        helper.searchContacts(component, sq, helper);
    },
    clearSearch : function (component, event, helper) {
        console.log('clearSearch');
        helper.clearData(component);
    },
    navToObject: function (component, event, helper) {
        console.log('navToObject');
        console.log(event);
        var objectId = '0030Y000002w9zdQAA';
        if ( $A.util.isEmpty(objectId) ) {
            return;
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/" + objectId
        });
        urlEvent.fire();
    },
    showDetails: function (component, event, helper) {
        console.log('showDetails');
        console.log(event);

        //var objectId = '0030Y000002w9zdQAA';
        var ct = component.get('v.listContacts')[0];
        component.set('v.curContact',ct);
/*
        if ( $A.util.isEmpty(objectId) ) {
            return;
        }
*/
    },
    closeObject: function (component, event, helper) {
        //component.set('v.contactId','');
        component.set('v.curContact',[]);
    }
})




