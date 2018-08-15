Rails & Backbone.js Example
---

By following the steps in this readme you should be able to create your own Rails application using Backbone.js for the front end. I'm assuming here that you already have ruby installed on your system and have already added the rails gem. Basically, your development environment is setup and start building. If this isn't you, I'd recommend following at least this guide: 

[http://installrails.com/](http://installrails.com/) 

Or preferably this guide for being able to keep multiple versions of ruby and rails via gemsets using rbenv:
 
 [https://github.com/rbenv/rbenv](https://github.com/rbenv/rbenv)

#### Definitions / Explanations

Here I will briefly cover the "layers" of both Rails and Backbone and show the directories where these layers typically exist within a rails project. The tilde (~) denotes the rails root directory, wherever that may exist on your own system.

#### Rails

* __Models__ (~/app/models) - associated with the tables in a database

* __Controllers__ (~/app/controllers) - provide endpoints for clients (browsers) and respond to requests via actions (their methods)

* __Views__ (~/app/views) - use the data provided from their controller action and format it (via templates) for consumption by the client

* __Routes__ (~/app/config/routes.rb) - defines the end points for the server, maps the URLs the client uses to code running on the server

#### Backbone.js

* __Models__ (~/app/assets/javascripts/models) - a container for data from the server, moves data to and from the server

* __Collections__ (~/app/assets/javascripts/collections) - an object that contains a list of Backbone.js models and does extra stuff like wiring up events to listen to changes in the models, don't think of it as an array or traditional *list* like exists in any other language

* __Views__ (~/app/assets/javascripts/views) - a JavaScript object that uses the model data to interact with the template, can react to changes in a model or the DOM

* __Templates__ (~/app/assets/javascripts/templates) - a container for HTML that represents the data from the view

* __Routers__ (~/app/assets/javascripts/routers) - intercepts URL requests in the browser and maps them to a Backbone.js model & view, a route on the client does not need to correspond to a route on the server

#### Syntax

This probably doesn't need to be said but I wanted to be explicit. Samples that need to be run from the command line:

> $ will look like this

...and actual code (within in files) will look like this:

```
class Something
    
    def initialize
    
    end
    
end
```

Let's get started...
---

Let's set the stage. You've taken a contract to build an online order entry system for a customer called Spatula Emporium. They intend on hiring a designer later as part of their re-branding campaign so your job is to provide a web application with all the logic and plumbing in place without any need for graphics or style. They also want mobile apps that work off the API that you will build but that will be a different initiative for a later time. For now you'll need to provide that framework.

First we need a new rails application:
> $ cd ~/whatever/directory/iwant/mynew/rails/app/tobe

> $ rails new spatula_emporium

