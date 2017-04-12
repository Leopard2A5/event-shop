require 'json'

Orders::App.controllers '/orders', :produces => :json do

  get '/' do
    Order.all.to_json
  end

  get '/:id' do
    order = Order.find_by_id(params['id'])
    halt 404 unless order

    order.to_json
  end

  post '/', params: [:customer_id, :amount] do
    order = Order.new(params.merge({status: 'CREATED'}))
    if order.valid?
      order.save
      order.to_json
    else
      [400, "#{order.errors.messages.to_json}"]
    end
  end

end
