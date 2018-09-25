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

```
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

```
class Spatula < ApplicationRecord
end
```
```
class Customer < ApplicationRecord
end
```
```
class ShippingLocation < ApplicationRecord
end
```
```
class Order < ApplicationRecord
  belongs_to :customer
end
```
```
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

```
class Customer < ApplicationRecord
  has_many :orders
end
```
```
class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_lines
end
```
```
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

```
class ShippingLocation < ApplicationRecord
  belongs_to :customer
end
```
```
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

```
Rails.application.routes.draw do
  get 'spatula/index'
  get 'spatula/new'
  get 'spatula/show'
  get 'spatula/update'
end
```

Using this, when you make a GET request to "http://yourserver.com/spatula/index" what would be returned from the "index" controller action is a list of spatulas.

```
class SpatulaController < ApplicationController

  def index
    @spatulas = Spatula.all
  end
  
  ...(the rest of the spatula_controller.rb file)
```

Let's run the rails server and see what shows up initially.

> bundle exec rails server -p 3000

Doing this runs the server for port 3000, now you can open a browser and go to "http://localhost:3000/spatula/index" which will display a message about which view is being accessed:

```
Spatula#index

Find me in app/views/spatula/index.html.erb
```
Press [ctrl]+c to quit the server.

For this project we'll enable all possible routes which will cover the controller actions that have been setup so far and any others in the event we need them. It'll also clean up the routes file nicely by keeping it small. 

```
Rails.application.routes.draw do
  resources :customer
  resources :order
  resources :shipping_location
  resources :spatula
end
```
Run the Rails server again and navigate again to "http://localhost:3000/spatula/index". This time you get an error:

```

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

[commit]()

##### Views

Backbone.js
---

##### Models

##### Collections

##### Views

##### Templates

##### Routers