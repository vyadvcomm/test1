/**
 * Created by viktor on 08.11.16.
 */
({
      cSearchContacts: function(component, accountId) {
            if ( $A.util.isEmpty(accountId) ) return;
            var action = component.get("c.sFindContactsByAccountId");
            action.setParams({
                "accountId": accountId
            });
            action.setCallback(this, function(response){
                console.log(response);
                var state = response.getState();

                if (component.isValid() && state === "SUCCESS") {
                    //TODO move to controller
                    var listContacts = component.get("v.listContacts");
                    listContacts = response.getReturnValue();
                    console.log(listContacts);
                    component.set("v.listContacts", listContacts);
                }
            });
        $A.enqueueAction(action);
      }
})