/**
 * Created by viktor on 07.11.16.
 */
({
     /*showSpinner : function (component, event, helper) {
         console.log('wait');
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();
    },

    hideSpinner : function (component, event, helper) {
       console.log('done');
       var spinner = component.find('spinner');
       var evt = spinner.get("e.toggle");
       evt.setParams({ isVisible : false });
       evt.fire();
    },*/
    searchAccount : function (component, event, helper ) {
        console.log('search account: '+ event.getName()); //
        var sq = component.get('v.searchQuery');
        console.log(sq);
        if ( $A.util.isEmpty(sq) ) {
            return;
        }
        var spinner = component.find('search-spinner');
        $A.util.addClass(spinner, 'slds-show');
        $A.util.removeClass(spinner, 'slds-hide');
        helper.searchAccounts(component, sq);
    },
    clearSearch : function (component, event, helper ) {
        console.log('clear account');
        component.set('v.searchQuery', '');
        component.set("v.listAccounts", []);
    },
    showContacts : function (component, event, helper ) {
        var accId = event.target ? (event.target.getAttribute('data-account-id') || '') : '';
        // FIXME check if it real id
        if ( $A.util.isEmpty(accId) ) return;
        console.log('Select contacts by account Id: ' + accId);
        component.set('v.AccountId', accId);
        component.set('v.searchQuery', event.target.innerText);
        component.set("v.listAccounts", []);
    },
    setPageSize : function (component, event, helper ) {
        var ipp = event.detail.menuItem.get('v.value');
        component.set('v.itemsPerPage', ipp);
        console.log('Set items per page: ' + ipp);
        console.log(component.get('v.itemsPerPage'));
        var el = component.find('el_items');
        el.set('v.visible', false);
        el.focus();
    }
})