Rails.application.routes.draw do
  get 'order/index'
  get 'order/new'
  get 'order/show'
  get 'order/update'
  get 'shipping_location/index'
  get 'shipping_location/new'
  get 'shipping_location/show'
  get 'shipping_location/update'
  get 'customer/index'
  get 'customer/new'
  get 'customer/show'
  get 'customer/update'
  get 'spatula/index'
  get 'spatula/new'
  get 'spatula/show'
  get 'spatula/update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
