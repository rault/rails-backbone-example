App.Models.Customer = Backbone.Model.extend({
    urlRoot: '/customer',
    defaults: {
        "name": "",
        "zip_code": ""
    },
});