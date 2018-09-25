App.Models.ShippingLocation = Backbone.Model.extend({
    urlRoot: '/shipping_location',
    defaults: {
        "name": "",
        "zip_code": ""
    },
});