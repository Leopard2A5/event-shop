require 'json'

Orders::App.controllers '/orders', :produces => :json do

  get '/' do
    Order.all.to_json
  end

  post '/' do
    order = Order.new(params)
    if order.valid?
      order.save.to_json
    else
      [400, "Invalid request"]
    end
  end

end
