App.Models.Order = Backbone.Model.extend({
    urlRoot: '/order',
    defaults: {
        "order_number": "",
        "customer_id": ""
    },
});