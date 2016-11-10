/**
 * Created by viktor on 08.11.16.
 */
({
	cDoInit: function(component, event, helper) {
        var accId = component.get('v.AccountId');
        console.log('Initialize by account Id: ' + accId);
        if ( $A.util.isEmpty(accId) ) return;
        helper.cSearchContacts(component, accId);
    },
    cOpenPreviousPage: function(cmp, event, helper) {
        var p = cmp.get('v.currentPage');

        if (p > 1) {
            cmp.set('v.currentPage', p - 1);
            //helper.retrieveItems(cmp);
            //helper.scrollToTop();
        }
    },
    cOpenNextPage: function(cmp, event, helper) {
        var p = cmp.get('v.currentPage'),
            pagesTotal = cmp.get('v.pagesTotal');

        if (p < pagesTotal) {
            cmp.set('v.currentPage', p + 1);
            //helper.retrieveItems(cmp);
            //helper.scrollToTop();
        }
    },

})