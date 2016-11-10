/**
 * Created by viktor on 08.11.16.
 */
({
    showLoader: function(component) {
        var spinner = component.find('search-spinner');
        $A.util.addClass(spinner, 'slds-show');
        $A.util.removeClass(spinner, 'slds-hide');
    },
    hideLoader: function(component) {
        var spinner = component.find('search-spinner');
        $A.util.removeClass(spinner, 'slds-show');
        $A.util.addClass(spinner, 'slds-hide');
    },
    clearData: function(component) {
        component.set('v.searchQuery', '');
        component.set("v.listContacts", []);
    },
    searchContacts: function(component, searchKey, helper) {
        helper.clearData(component);
        helper.showLoader(component);
        var action = component.get("c.findContactByName");
        action.setParams({
            "searchKey": searchKey,
            "itemsPerPage": component.get('v.itemsPerPage')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            helper.hideLoader(component);
            if (component.isValid() && state === "SUCCESS") {
                //TODO move to controller
                var listContacts = component.get("v.listContacts");
                listContacts = response.getReturnValue();
                component.set("v.listContacts", listContacts);
            } else {
                console.log(response);
            }
        });
    $A.enqueueAction(action);
      }
})