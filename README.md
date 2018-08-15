Rails & Backbone.js Example
---

By following the steps in this readme you should be able to create your own Rails application using Backbone.js for the front end. I'm assuming you already have ruby installed and already added the rails gem. Basically, your development environment is setup to start building. If not I'd recommend following at least this guide: 

[http://installrails.com/](http://installrails.com/) 

Or preferably this guide for being able to keep multiple versions of ruby and rails via gemsets using rbenv:
 
 [https://github.com/rbenv/rbenv](https://github.com/rbenv/rbenv)

And if you're new to Rails, this guide will walk you through your first Rails application:

[https://guides.rubyonrails.org/getting_started.html](https://guides.rubyonrails.org/getting_started.html)

#### Definitions / Explanations

Here I will briefly cover the "layers" of both Rails and Backbone and show the directories where these layers typically exist within a rails project. The tilde (~) denotes the rails root directory, wherever that may exist on your own system.

#### Rails

* __Models__ (~/app/models) - generally represent the tables in a database, but don't necessarily have to

* __Controllers__ (~/app/controllers) - provide endpoints for clients (browsers) and respond to requests via *actions* (their methods)

* __Views__ (~/app/views) - use the data provided from their controller action and format it (via templates) for consumption by the client

* __Routes__ (~/app/config/routes.rb) - defines the endpoints (URIs) for the server, maps the URLs the client uses to code running on the server

#### Backbone.js

* __Models__ (~/app/assets/javascripts/models) - a container for data from the server, moves data to and from the server

* __Collections__ (~/app/assets/javascripts/collections) - an object that contains an array of Backbone.js models and does extra stuff like wiring up events to listen to changes in the models, don't think of the collection itself as an array or traditional *list* like exists in any other language, a Backbone.js collection is kind of its own thing

* __Views__ (~/app/assets/javascripts/views) - a JavaScript object that uses the model (data) to interact with the template, can react to changes in the model or the DOM

* __Templates__ (~/app/assets/javascripts/templates) - a container for HTML that represents the model data via the view

* __Routers__ (~/app/assets/javascripts/routers) - intercepts URL requests in the browser and maps them to a Backbone.js model & view, a URL on the client does not need to correspond to a URL on the server

#### Syntax

This probably doesn't need to be said but I wanted to be explicit. Samples that need to be run from the command line:

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

Let's say you've taken a contract to build an online order entry system for a company called __Spatula Emporium__. They intend on hiring a designer later as part of their re-branding campaign (*spatula sales never recovered from the 2008 housing market crash*) so your job is to provide a web application with all the logic and plumbing in place without any need for graphics or style. They also eventually want mobile apps that work off the API that you build. That will be a separate initiative. For now you'll need to provide the framework.

###### Note: I won't be covering things like user or API authentication. This will only cover the basics of Rails and Backbone.js combined.

Rails
---

First we need a new rails application:
> cd ~/whatever/directory/iwant/mynew/rails/app/tobein

> rails new spatula_emporium

> cd spatula_emporium

[commit](d9dd59217ff6fe71f0b8768ee7bcafadae2acdc7)

Next we'll create our models. We'll just be using the default sqlite database but you can switch to something else if you want to. The models we'll need are:

* "Spatula" with attributes for color and price
* "Customer" with attributes for name and zip code
* "ShippingLocation" with attributes for name and zip code
* "Order" with attributes for order number and customer_id
* "OrderLine" with attributes for order_id, quantity, spatula_id, shipping_location_id

So we'll create them with these commands taking advantage of the Rails generator ability to understand model.

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

With the *belongs_to* relationships in place we can now do something like this while in the rails console:

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

This code now describes the relationships better because a spatula does not "own" an order line. Nor does an order line really belong to a spatula. What we're really trying to say is that an order line refers to one particular spatula. If we didn't include the *has_one* we could still refer to the spatula_id that an order line has as an attribute, but since we've included it we can refer to them as objects like so:
 
 > o = Order.first
 
 > l = o.order_lines.first
 
 > s = l.spatula
 
 I'm not adding *belongs_to* to the spatula class though because we don't have any business case for needing to look up an order line from it. 

If I spent any more time on this I'd be getting off track. My goal was to spend just long enough that you start to intuitively understand what is actually being built. You really need the ability to conceptualize the domain process if you are to model it in code no matter what you are building. 

With the models out of the way you'll need to create the database and run the migrations.

> bundle exec rake db:create

> bundle exec rake db:migrate

 Let's check that these exist by trying to look up an order. There's no data so I wouldn't expect anything to come back but it should work without throwing an error.

> bundle exec rails console 

> irb(main):001:0> o = Order.first

And the result looks ok.

>   Order Load (0.2ms)  SELECT  "orders".* FROM "orders" ORDER BY "orders"."id" ASC LIMIT ?  [["LIMIT", 1]]

> => nil

So let's exit the rails console.

> irb(main):002:0> exit



```

```

