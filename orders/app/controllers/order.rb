require 'json'

Orders::App.controllers '/orders', :produces => :json do

  get '/' do
    Order.all.to_json
  end

end
