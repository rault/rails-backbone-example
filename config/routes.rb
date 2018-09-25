Rails.application.routes.draw do
  resources :customer
  resources :order
  resources :shipping_location
  resources :spatula
end
