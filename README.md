Rails & Backbone.js Example
---

By following the steps in this readme you should be able to create your own Rails application using Backbone.js for the front end. I'm assuming you already have ruby installed and already added the rails gem. Basically, your development environment is setup to start building. If not I'd recommend following at least this guide: 

[http://installrails.com/](http://installrails.com/) 

Or preferably this guide for being able to keep multiple versions of ruby and rails via gemsets using rbenv:
 
 [https://github.com/rbenv/rbenv](https://github.com/rbenv/rbenv)

And if you're new to Rails, this guide will walk you through your first Rails application:

[https://guides.rubyonrails.org/getting_started.html](https://guides.rubyonrails.org/getting_started.html)

I make the assumption you've already gone through that tutorial in this guide. If you're already somewhat familiar with Rails you probably don't need it..

#### Definitions / Explanations

Here I will briefly cover the "layers" of both Rails and Backbone and show the directories where these layers typically exist within a rails project. The tilde (~) denotes the rails application root directory, wherever that may exist on your own system.

#### Rails

* __Models__ (~/app/models) - generally represent the tables in a database, but don't necessarily have toa, in theory, a structural representation of data in code

* __Controllers__ (~/app/controllers) - provide endpoints for clients (browsers) and respond to requests via *actions* (their methods)

* __Views__ (~/app/views) - use the data provided from their controller action (not necessarily a model) and format it (via templates) for consumption by the client

* __Routes__ (~/app/config/routes.rb) - defines the endpoints (URIs) for the server, maps the URLs the client uses to controller actions on the server, these don't have to be the same

#### Backbone.js

* __Models__ (~/app/assets/javascripts/models) - a container for data from the server, moves data to and from the server, roughly analogous to a Rails model which similarly ought to contain any functions that interact with the data represented by the model

* __Collections__ (~/app/assets/javascripts/collections) - an object *that contains an array* of Backbone.js models and does extra stuff like wiring up events to listen to changes in the models, don't think of the collection itself as an array or traditional list like other languages, a Backbone.js collection is kind of its own thing, in that light the name is...unfortunate

* __Views__ (~/app/assets/javascripts/views) - a JavaScript object that uses the model (data) to interact with the template, a view can react to changes in the model or the DOM, its meant to contain JavaScript events and functions that deal with the layout and presentation of you model data in the template

* __Templates__ (~/app/assets/javascripts/templates) - a container for HTML that represents the model data via the view, the inline code in a view ought to be familiar to anyone that's worked with just HTML and JavaScript 

* __Routers__ (~/app/assets/javascripts/routers) - intercepts URL requests in the browser and maps them to a Backbone.js model & view, a URL on the client does not need to correspond to a URL on the server, this too is roughly analogous to the rails routes

#### Syntax

This probably doesn't need to be said but I wanted to be explicit. Code samples in this guide that need to be run from the command line:

> will look like this

...and actual code (within in files) will look like this:

```ruby
class Something
    
    def initialize
    
    end
    
end
```

Let's get started...
---

We'll pretend you've taken a contract to build an online order entry system for a company called __Spatula Emporium__. They intend on hiring a designer later as part of their re-branding campaign (*spatula sales still haven't recovered from the 2008 housing market crash*) so your job is to provide a web application with all the logic and plumbing in place without any need for graphics or style. They also eventually want mobile apps that work off the API that you build. That will be a separate initiative. For now you'll need to provide the web application framework.

###### Note: I won't be covering things like user or API authentication. This will only cover the basics of Rails and Backbone.js combined.

Rails
---

First create a new rails application:

> cd ~/whatever/directory/iwant/mynew/rails/app/tobein

> rails new spatula_emporium

> cd spatula_emporium

[commit](https://github.com/rault/rails-backbone-example/commit/d9dd59217ff6fe71f0b8768ee7bcafadae2acdc7)

##### Models

This example application is using the default sqlite database but you can switch to something else if you want to. Using the rails generator will create the database migrations making it easy to get up and running quickly. The models needed for this new order entry system are :

* "Spatula" with attributes for color and price
* "Customer" with attributes for name and zip code
* "ShippingLocation" with attributes for name and zip code
* "Order" with attributes for order number and customer_id
* "OrderLine" with attributes for order_id, quantity, spatula_id, shipping_location_id

Create them with these commands taking advantage of the Rails generator.

> bundle exec rails generate model Spatula color:string price:decimal

> bundle exec rails generate model Customer name:string zip_code:integer

> bundle exec rails generate model ShippingLocation name:string zip_code:integer

> bundle exec rails generate model Order order_number:string customer:references

> bundle exec rails generate model OrderLine order:references quantity:integer spatula:references shipping_location:references

And you'll get models looking like these:

```ruby
class Spatula < ApplicationRecord
end
```
```ruby
class Customer < ApplicationRecord
end
```
```ruby
class ShippingLocation < ApplicationRecord
end
```
```ruby
class Order < ApplicationRecord
  belongs_to :customer
end
```
```ruby
class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :spatula
  belongs_to :shipping_location
end
```

With the *belongs_to* relationships in place you can now do something like this while in the rails console:

> o = Order.first

> c = o.customer

That allows us to refer to the customer for that specific order without having to write code to perform a lookup ourselves. Defining the relationships in your models is based on not only how they relate to one another but how you expect to use them elsewhere in your code base.

Here I'm adding or changing a couple *belong_to* to *has_many* or *has_one* to the classes where that makes sense. 

```ruby
class Customer < ApplicationRecord
  has_many :orders
end
```
```ruby
class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_lines
end
```
```ruby
class OrderLine < ApplicationRecord
  belongs_to :order
  has_one :spatula
  has_one :shipping_location
end
```

This code now describes the relationships better because a spatula does not "own" an order line. Nor does an order line really belong to a spatula. An order line refers to one particular spatula. If *has_one* wasn't included the spatula_id still exists for the order line as an attribute, since *has_one* is included it can be referred to as an object like so:
 
 > o = Order.first
 
 > l = o.order_lines.first
 
 > s = l.spatula
 
 I'm not adding *belongs_to* to the spatula class though because there isn't a business case for needing to look up an order line from it. 

If I spent any more time on this I'd be getting off track. My goal was to spend just long enough that you start to intuitively understand what is actually being built. You really need the ability to conceptualize the domain process if you are to model it in code no matter what you are building. 

With the models out of the way you'll need to create the database and run the migrationsa, which we didn't need to create because we used a rails genrerator.

> bundle exec rake db:create

> bundle exec rake db:migrate

 Let's check that these exist by trying to look up an order. There's no data so I wouldn't expect anything to come back but it should work without throwing an error.

> bundle exec rails console 

> irb(main):001:0> o = Order.first

And the result looks ok because no orders have been created yet.

>   Order Load (0.2ms)  SELECT  "orders".* FROM "orders" ORDER BY "orders"."id" ASC LIMIT ?  [["LIMIT", 1]]

> => nil

So let's exit the rails console.

> irb(main):002:0> exit

[commit](https://github.com/rault/rails-backbone-example/commit/151ac4b65958a49de6d8dfd1d882395eaff63f1d)

##### Changing the Models

We need to have ShippingLocations be a child of Customer. This doesn't really matter in this example application but in the real world you'd expect a shipping location to have a real address which makes it specific to a customer. Something like a single corporate entity owning multiple stores. So let's fix that. 

Create a migration to add customer_id to the shipping_locations table. 

> bundle exec rails generate migration add_customer_id_to_shipping_locations customer_id:"integer{8}"

> bundle exec rake db:migrate

Now let's check to make sure it was changed:

> bundle exec rails console

> irb(main):004:0> s = ShippingLocation.new

>  => #<ShippingLocation id: nil, name: nil, zip_code: nil, created_at: nil, updated_at: nil, customer_id: nil>

We can see the customer_id field being included in the attributes. One last thing though...change the *belongs_to* in the Customer class to *has_many* like so:

```ruby
class ShippingLocation < ApplicationRecord
  belongs_to :customer
end
```
```ruby
class Customer < ApplicationRecord
  has_many :shipping_locations
  has_many :orders
end
```
[commit](https://github.com/rault/rails-backbone-example/commit/d55065603a8207e053583ad54385fab2ca5705e5)

##### Controllers

The controllers are going to provide the data for our API. The mappings could be 1:1 of models to controllers except for orders. It doesn't make sense for order lines to exist separate from an order except in the database where we don't want to repeat order information for each line. In database speak this is called "normalization". Conceptually they're really just one thing anyway, an "order". From our APIs perspective this will be the only way the orders and their lines will be used. So it makes sense to have a single controller that combines the two models.

Another requirement from Spatula Emporium is that data can't really be deleted. Maybe its an auditing compliance thing. If a customer goes away their records will need updated to show a "deleted" state and the orders will be updated to show a "cancelled" state. To accommodate this, create migrations adding a deleted field to the tables and a cancelled field on the order and order lines.

> rails 

> bundle exec rails generate migration add_deleted_to_spatulas deleted:boolean

> bundle exec rails generate migration add_deleted_to_customers deleted:boolean

> bundle exec rails generate migration add_deleted_to_shipping_locations deleted:boolean

> bundle exec rails generate migration add_cancelled_to_orders cancelled:boolean

> bundle exec rails generate migration add_cancelled_to_order_lines cancelled:boolean

Run db:migrate again then spot-check these in the Rails console too, you should see the deleted field being included in the output:

> bundle exec rails console

> Spatula.new

> Order.new

Now we can create the controllers and we'll also use the Rails generator for these:

> bundle exec rails generate controller Spatula index show new edit create update destroy

> bundle exec rails generate controller Customer index show new edit create update destroy

> bundle exec rails generate controller ShippingLocation index show new edit create update destroy

> bundle exec rails generate controller Order index show new edit create update destroy

The controller code will be very similar as what's covered in the [Rails Getting Started](https://guides.rubyonrails.org/getting_started.html) walk through except the destroy action will update the deleted or cancelled fields (for orders and order lines). 

[commit](https://github.com/rault/rails-backbone-example/commit/06f78c73a092e2bbaeaa9089687b0f7d604bd0fe)

For a brief overview of controllers and their intended usage, see this table from the Code Academy article: [Standard Controller Actions](https://www.codecademy.com/articles/standard-controller-actions)
<span style="background-color:white">
![table of controller actions mapped to HTTP verbs](https://s3.amazonaws.com/codecademy-content/projects/3/seven-actions.svg)
</span>

This commit can be ignored but I'm including it for reference. The changes are edits to the readme for context and better explanations. [commit](https://github.com/rault/rails-backbone-example/commit/a1e765333c99dc31a68bc3f21ee19777e41aa8e3)

##### Routes

Rails uses what's in the routes.rb file to register pathways when requests come into the server. It defines what clients (like browsers or requests from within JavaScript) can see. Now that the controllers and actions are in place we could create our routes for spatulas with their intended HTTP verb liks o:

```ruby
Rails.application.routes.draw do
  get 'spatula/index'
  get 'spatula/new'
  get 'spatula/show'
  get 'spatula/update'
end
```

Using this, when you make a GET request to "http://yourserver.com/spatula/index" what would be returned from the "index" controller action is a list of spatulas.

```ruby
class SpatulaController < ApplicationController

  def index
    @spatulas = Spatula.all
  end
  
  ...(the rest of the spatula_controller.rb file)
```

Let's run the rails server and see what shows up initially.

> bundle exec rails server -p 3000

Doing this runs the server for port 3000, now you can open a browser and go to "http://localhost:3000/spatula/index" which will display a message about which view is being accessed:

```text
Spatula#index

Find me in app/views/spatula/index.html.erb
```
Press [ctrl]+c to quit the server.

For this project we'll enable all possible routes which will cover the controller actions that have been setup so far and any others in the event we need them. It'll also clean up the routes file nicely by keeping it small. 

```ruby
Rails.application.routes.draw do
  resources :customer
  resources :order
  resources :shipping_location
  resources :spatula
end
```
Run the Rails server again and navigate again to "http://localhost:3000/spatula/index". This time you get an error:

```text
ActiveRecord::RecordNotFound in SpatulaController#show
Couldn't find Spatula with 'id'=index
Extracted source (around line #8):

  def show
    @spatula = Spatula.find(params[:id])
  end

  def new

Rails.root: /Users/robault/Documents/GitHub/rails-backbone-example.git
Application Trace | Framework Trace | Full Trace

app/controllers/spatula_controller.rb:8:in `show'

Request

Parameters:

{"id"=>"index"}

Toggle session dump
Toggle env dump
Response

Headers:

None
```

When Rails handles the routes (by us defining them using the keyword "resources") "index" is treated special in that it is the default request recognized by the server, so the URL actually needs to be "http://yourserver.com/spatula/" and you will receive the same non-error result as before. Anything after  "spatula/" will be interpreted as an ID number which calls the "show" action. The other actions assume they'll be receiving some information to work with as well. Updates require the id of the object and the attribute data so it knows what and how to change the corresponding record in the database. Likewise a delete would need to know the id of which object its deleting.

I won't get much further into Rails routing because this guide actually covers it well enough for beginners. 

[Rails routing from the Outside In](https://guides.rubyonrails.org/routing.html)

[commit](https://github.com/rault/rails-backbone-example/commit/c6abde8deee53cf1eef051c87e226ed39f70352f)

##### Views

I will be very brief here because what you normally do with views in Rails isn't the same when you use Backbone. But I'll cover the index action for spatulas just to review.

The index action for spatulas returns a list of all of them in the instance variable "@spatulas":

```ruby
  def index
    @spatulas = Spatula.all
  end
```

To write the list out to HTML, change the ~/app/views/spatula/index.html.erb from this:

```text
<h1>Spatula#index</h1>
<p>Find me in app/views/spatula/index.html.erb</p>
```

...to this (notice the "=" indicating that a value needs to be evaluated rather than just ruby code like the ".each do"):

```html
<h1>Spatula#index</h1>
<br>
  <% @spatulas.each do |spatula| %>
    ID: <%= spatula.id %><br>
    Color: <%= spatula.color %><br>
    Price: <%= spatula.price %><br>
  <br><br>
  <% end %>
</p>
```
Run the Rails server again and go back to the spatula URL:

> bundle exec rails server -p 3000

There is no data yet so the output should be:

```text
Spatula#index
```
I'll save you from having to create you own data by providing some via a database seed file. 

I do want to mention, on my Mac I found I had to edit the permissions for the sqlite database files before running the seed file was successful. I just set "everyone" with read and write permissions for ease of use. You are free to make your own determination for security reasons though. The instructions for Mac OS are here:

[macOS Sierra: Set permissions for items on your Mac](https://support.apple.com/kb/ph25287?locale=en_US)

After that's done you can run the seed file like so:

> bundle exec rake db:seed

Reloading the spatula index page should now show this:

```text
Spatula#index

ID: 1
Color: Red
Price: 8.0


ID: 2
Color: Blue
Price: 6.0


ID: 3
Color: Purple
Price: 4.0

```

[commit](https://github.com/rault/rails-backbone-example/commit/5a6963c5ae6900b19c4dd8f3ee1027e7d856c192)

Backbone.js
---

Now for the *pièce de résistance*, Backbone.js. There are a couple different ways of adding backbone to your Rails application but for this tutorial we're going to add them manually because this introduces you to the Rails asset pipeline.

##### Setup

The download description for Backbone.js (at the time this tutorial was created) reads:

```text
Backbone's only hard dependency is Underscore.js ( >= 1.8.3). For RESTful persistence and DOM manipulation with Backbone.View, include jQuery ( >= 1.11.0), and json2.js for older Internet Explorer support. (Mimics of the Underscore and jQuery APIs, such as Lodash and Zepto, will also tend to work, with varying degrees of compatibility.)
``` 

We'll go ahead and add all of these, You can download them yourself or copy them from within this repository. I had a problem using the latest production backbone while making this tutorial, so I'm going to re-use a version I know to work (1.0.0). Place them all in "~/vendor/assets/javascripts", you'll need to create the full folder path.

Now add the require directives to the "~/app/assets/javascripts/application.js" file and stub the application structure, it should look like so:

```javascript
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
```
What you place in the vendor/assets folder becomes available to your application for use and keeps third party assets and libvraries separate from the code you create in your application. They won't be loaded unless your application is told about them which is why the application.js must require them. 

Run the rails server, go back to the spatula page and open the developer tools for the browser you are using. In the console type in:

> Backbone

You should see something like this indicating Backbone.js is being included in the page and is loading correctly.

```
  Object { VERSION: "1.0.0", "$": jQuery()
  , noConflict: noConflict(), emulateHTTP: false, emulateJSON: false, Events: {…}, on: on(), once: once(), off: off(), trigger: trigger(), … }
```

Likewise, you can now try these and they'll be recognized as name spaces in your JavaScript application structure:

> App.Models

> App.Collections

> App.Views

To put a point on it, go ahead and right click the page in the browser and view its source. The <head> block of HTML should look something like this:

```html
  <head>
    <title>SpatulaEmporium</title>
    <meta name="csrf-param" content="authenticity_token" />
    <meta name="csrf-token" content="LbO0LzVqh7uUStRXDj7lirW0QN+YX1FNwAj+q73hr2fiEg1xwW6go+arESdddtT5m2hnuU8faapDTnBDhDczgQ==" />
    <link rel="stylesheet" media="all" href="/assets/customer.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1" data-turbolinks-track="reload" />
    <link rel="stylesheet" media="all" href="/assets/order.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1" data-turbolinks-track="reload" />
    <link rel="stylesheet" media="all" href="/assets/shipping_location.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1" data-turbolinks-track="reload" />
    <link rel="stylesheet" media="all" href="/assets/spatula.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1" data-turbolinks-track="reload" />
    <link rel="stylesheet" media="all" href="/assets/application.self-f0d704deea029cf000697e2c0181ec173a1b474645466ed843eb5ee7bb215794.css?body=1" data-turbolinks-track="reload" />
    <script src="/assets/rails-ujs.self-3b600681e552d8090230990c0a2e8537aff48159bea540d275a620d272ba33a0.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/activestorage.self-0525629bb5bac7ed5f2bfc58a9679d75705e426dafd6957ae9879db97c8e9cbe.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/turbolinks.self-2db6ec539b9190f75e1d477b305df53d12904d5cafdd47c7ffd91ba25cbec128.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/json2.self-356614d2260c69b92680d59e99601dcd5e068f761756f22fb959b5562b9a7d62.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/jquery-3.1.1.self-355640bfbbb3239b9bb16d6795e41d526eeffc2eff3253d494fa3f58e2c3177c.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/underscore-1.8.3.min.self-4f5b2528815d8b1cd9b68b1a4bb1fe689696f8dcbc2c4a5104343b886ee68828.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/backbone-1.0.0.self-2ebbacdc8393dac4ce1d4cfbb8eb1957ba7bd7811fa7bed67c94a4a1193a78f3.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/application.self-4ac2742a3c953773bf9a9801a809e613cad45ab72577d949689d1df94aadc5c2.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/action_cable.self-69fddfcddf4fdef9828648f9330d6ce108b93b82b0b8d3affffc59a114853451.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/cable.self-8484513823f404ed0c0f039f75243bfdede7af7919dda65f2e66391252443ce9.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/customer.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/order.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/shipping_location.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1" data-turbolinks-track="reload"></script>
    <script src="/assets/spatula.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1" data-turbolinks-track="reload"></script>
  </head>
```

You can see the backbone, underscore, json2 and jquery javascript files being loaded in the page via script tags; something you would do if you were writing a HTML and JavaScript only application without the automated features and server side application in Rails.

[commit](https://github.com/rault/rails-backbone-example/commit/d17c54f58446f549403f6ce86aa0d7608b90458b)

Again, just editing for clarity and formatting: [commit](https://github.com/rault/rails-backbone-example/commit/a1e765333c99dc31a68bc3f21ee19777e41aa8e3)

##### Models

Now we're going to make our models. They all extend the base Model class provided by Backbone.js. Let's start with Spatula:

```javascript
App.Models.Spatula = Backbone.Model.extend({
    urlRoot: '/spatula',
    defaults: {
        "color": "",
        "price": ""
    },
});
```

Spatula is defined in the App.Models namespace that was setup in the application.js file. Extending from Backbone.Model sets up functions and events provided by Backbone.js. You can think of this backbone model as a proxy class for the Spatula class on the server. Out object is defined by the server but we "model" it on the client side using this Spatula model.

The urlRoot tells backbone where to look for the Rails route that provides the data for this model. This corresponds to the route for the object in the routes.rb file.

Setting defaults is unnecessary but I wanted to do it to illustrate what we expect to see when we tell backbone to get a spatula from the server. 

To test this out, make sure the Rails server is running and load or re-load the page. In the console type:

> var s = new App.Models.Spatula();

What you should see in response is:

> undefined

The line was a statement, not referencing an object or value so this is ok. Now type just "s" like so:

> s

What you will see is the object "s" (our Spatula object in JavaScript) output to the console:

> Object { cid: "c2", attributes: {…}, _changing: false, _previousAttributes: {}, changed: {}, _pending: false }

If you expand the object then expand attributes you will see both color and price being shown because the defaults were defined in the model:

```javascript
{…}
  _changing: false
  _pending: false
  _previousAttributes: Object {  }
  attributes: {…}
    color: ""
    price: ""
    <prototype>: Object { … }
  changed: Object {  }
  cid: "c2"
  <prototype>: Object { constructor: child(), urlRoot: "/spatulas", defaults: {…} }
```

Next we'll request a spatula from the server. Look at the HTML page and choose one of the IDs and add it to this call to fetch, my ID is 13:

> s.fetch(13)

Initially the response looks similar to the object response above. If you expand it you'll see a property called "responseText" In it is the HTML for the spatula page from the index action on the server.

```javascript
"<!DOCTYPE html>\n<html>\n <head>\n <title>SpatulaEmporium</title>\n <meta name=\"csrf-param\" content=\"authenticity_token\" />\n<meta name=\"csrf-token\" content=\"R2TZCIcxuAVO6SM3kEWXJptmiVTty7ttD8PHmsR5vpuIxWBWczWfHTwI5kfDDaZVtbquMjqLg4qMhUly/a8ifQ==\" />\n \n\n <link rel=\"stylesheet\" media=\"all\" href=\"/assets/customer.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1\" data-turbolinks-track=\"reload\" />\n<link rel=\"stylesheet\" media=\"all\" href=\"/assets/order.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1\" data-turbolinks-track=\"reload\" />\n<link rel=\"stylesheet\" media=\"all\" href=\"/assets/shipping_location.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1\" data-turbolinks-track=\"reload\" />\n<link rel=\"stylesheet\" media=\"all\" href=\"/assets/spatula.self-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css?body=1\" data-turbolinks-track=\"reload\" />\n<link rel=\"stylesheet\" media=\"all\" href=\"/assets/application.self-f0d704deea029cf000697e2c0181ec173a1b474645466ed843eb5ee7bb215794.css?body=1\" data-turbolinks-track=\"reload\" />\n <script src=\"/assets/rails-ujs.self-3b600681e552d8090230990c0a2e8537aff48159bea540d275a620d272ba33a0.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/activestorage.self-0525629bb5bac7ed5f2bfc58a9679d75705e426dafd6957ae9879db97c8e9cbe.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/turbolinks.self-2db6ec539b9190f75e1d477b305df53d12904d5cafdd47c7ffd91ba25cbec128.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/json2.self-356614d2260c69b92680d59e99601dcd5e068f761756f22fb959b5562b9a7d62.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/jquery-3.1.1.self-355640bfbbb3239b9bb16d6795e41d526eeffc2eff3253d494fa3f58e2c3177c.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/underscore-1.8.3.min.self-4f5b2528815d8b1cd9b68b1a4bb1fe689696f8dcbc2c4a5104343b886ee68828.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/backbone-1.0.0.self-2ebbacdc8393dac4ce1d4cfbb8eb1957ba7bd7811fa7bed67c94a4a1193a78f3.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/application.self-4ac2742a3c953773bf9a9801a809e613cad45ab72577d949689d1df94aadc5c2.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/models/customer.self-ff49112cc7532541b05a81ee8879a94cabe4bb5680e3ab316f8f1398900fb4ae.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/models/order.self-785985f7ee6d4b86662fa8d2dd992c92d87ed09996f148b2f7a11e54865c7022.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/models/shipping_location.self-a36a60ee4d15d5c81682beae09923613eafbeb650c32a5da8a1dfcf461187732.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/models/spatula.self-b78d01298ef5837528b16750b5397e650321f31ee059c7de93e81aa00170aabb.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/action_cable.self-69fddfcddf4fdef9828648f9330d6ce108b93b82b0b8d3affffc59a114853451.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/cable.self-8484513823f404ed0c0f039f75243bfdede7af7919dda65f2e66391252443ce9.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/customer.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/order.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/shipping_location.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1\" data-turbolinks-track=\"reload\"></script>\n<script src=\"/assets/spatula.self-877aef30ae1b040ab8a3aba4e3e309a11d7f2612f44dde450b5c157aa5f95c05.js?body=1\" data-turbolinks-track=\"reload\"></script>\n </head>\n\n <body>\n <h1>Spatula#index</h1>\n<br>\n ID: 13<br>\n Color: Red<br>\n Price: 8.0<br>\n <br><br>\n ID: 14<br>\n Color: Blue<br>\n Price: 6.0<br>\n <br><br>\n ID: 15<br>\n Color: Purple<br>\n Price: 4.0<br>\n <br><br>\n</p>\n </body>\n</html>\n"
```

Buried in the responseText is the HTML generated from the view in Rails:

```html
<br>\n ID: 13<br>\n Color: Red<br>\n Price: 8.0<br>\n <br><br>\n ID: 14<br>\n Color: Blue<br>\n Price: 6.0<br>\n <br><br>\n ID: 15<br>\n Color: Purple<br>\n Price: 4.0<br>\n <br><br>>
```

This makes sense actually. We set Rails up to respond to a request at "/spatula" with the index action and we've just told our model to go there when asking for a spatula with a specific ID.

What we want is for the server to respond with JSON that fills our model's attributes. Passing an ID to backbone's "fetch" should correspond to the "show" action on the server which should give us back the spatula we're talking about.

The reason it isn't doing this is because we haven't setup routes yet. So let's do that next.

For reference, the other models are defined within their own files like so:

```javascript
App.Models.Customer = Backbone.Model.extend({
    urlRoot: '/customer',
    defaults: {
        "name": "",
        "zip_code": ""
    },
});

App.Models.Order = Backbone.Model.extend({
    urlRoot: '/order',
    defaults: {
        "order_number": "",
        "customer_id": ""
    },
});

App.Models.ShippingLocation = Backbone.Model.extend({
    urlRoot: '/shipping_location',
    defaults: {
        "name": "",
        "zip_code": ""
    },
});
```

[commit]()

##### Routers

##### Collections

##### Views

##### Templates