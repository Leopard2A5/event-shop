module Orders
  class App < Padrino::Application
    use ConnectionPoolManagement
    register RabbitMQInitializer
  end
end
