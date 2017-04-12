require 'rack/parser'

module Orders
  class App < Padrino::Application
    use ConnectionPoolManagement
    register RabbitMQInitializer

    use Rack::Parser, content_types: {
      'application/json': Proc.new do |body|
        ::MultiJson.decode body
      end
    }
  end
end
