// Rails default libraries
//= require rails-ujs
//= require activestorage
//= require turbolinks

// Libraries we've added
//= require json2
//= require jquery-3.1.1
//= require underscore-1.8.3.min
//= require backbone-1.0.0.js


// Paths for backbone.js files
//= require_self
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./routers
//= require_tree ./views
//= require_tree .

// Setting up backbone
window.App = {
    Models: {},
    Collections: {},
    Views: {}
};