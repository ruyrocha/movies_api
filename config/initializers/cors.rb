Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3000', 'localhost:8080', 'localhost:4040'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
