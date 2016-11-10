/**
 * Created by viktor on 08.11.16.
 */
({
      searchAccounts: function(component, searchKey) {
            if ( $A.util.isEmpty(searchKey) ) return;
            var action = component.get("c.sFindAccountByName");
            action.setParams({
                "searchKey": searchKey
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    //TODO move to controller
                    var spinner = component.find('search-spinner');
                    $A.util.removeClass(spinner, 'slds-show');
                    $A.util.addClass(spinner, 'slds-hide');
                    var listAccounts = component.get("v.listAccounts");
                    listAccounts = response.getReturnValue();
                    component.set("v.listAccounts", listAccounts);
                }
            });
        $A.enqueueAction(action);
      }
})