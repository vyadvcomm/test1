/**
 * Created by viktor on 07.11.16.
 */
({
     showSpinner : function (component, event, helper) {
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
    },
    searchAccount : function (component, event, helper ) {
        console.log(event);
    },
    clearSearch : function (component, event, helper ) {
         console.log(event);
    }
})