ActiveRecord::Base.logger = Logger.new(STDOUT)

OrderLine.destroy_all
Order.destroy_all
Spatula.destroy_all
ShippingLocation.destroy_all
Customer.destroy_all

barry = Customer.new(name: 'Barry Allen', zip_code: 12345)
joe = Customer.new(name: 'Joe West', zip_code: 12345)
iris = Customer.new(name: 'Iris West', zip_code: 12345)

barry.save
joe.save
iris.save

star_labs = ShippingLocation.new(name: 'Star Labs', zip_code: 12345, customer: barry)
ccpd = ShippingLocation.new(name: 'CCPD', zip_code: 12345, customer: joe)
picture_news = ShippingLocation.new(name: 'Picture News', zip_code: 12345, customer: iris)
star_labs.save
ccpd.save
picture_news.save

flashula = Spatula.new(color: 'Red', price: '08.00'.to_f)
policula = Spatula.new(color: 'Blue', price: '06.00'.to_f)
newsula = Spatula.new(color: 'Purple', price: '04.00'.to_f)
flashula.save
policula.save
newsula.save

barrys_order_params = { order: {
    order_number: '1001',
    customer_id: barry.id,
    order_lines_attributes: [
        { quantity: 1, spatula_id: policula.id, shipping_location_id: ccpd.id },
        { quantity: 1, spatula_id: newsula.id, shipping_location_id: picture_news.id }
    ]
}}
Order.create(barrys_order_params[:order])

joess_order_params = { order: {
    order_number: '1002',
    customer_id: joe.id,
    order_lines_attributes: [
        { quantity: 1, spatula_id: flashula.id, shipping_location_id: star_labs.id },
        { quantity: 1, spatula_id: newsula.id, shipping_location_id: picture_news.id }
    ]
}}
Order.create(joess_order_params[:order])

iriss_order_params = { order: {
    order_number: '1003',
    customer_id: iris.id,
    order_lines_attributes: [
        { quantity: 1, spatula_id: policula.id, shipping_location_id: ccpd.id },
        { quantity: 1, spatula_id: flashula.id, shipping_location_id: star_labs.id }
    ]
}}
Order.create(iriss_order_params[:order])
