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
        if ( $A.util.isEmpty(sq) ) {
            return;
        }
        if ( sq.length < 3 ) { // TODO make cache
            return;
        }
        helper.searchContacts(component, sq, helper);
    },
    clearSearch : function (component, event, helper) {
        console.log('clear search');
        helper.clearData(component);
    }
})




