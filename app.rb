require 'sinatra'
require 'json'
require 'swagger/blocks'

class WebhookApp < Sinatra::Base
  include Swagger::Blocks

  # Definir el esquema raíz de Swagger
  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Webhook API'
      key :description, 'API para gestionar webhooks'
    end
    key :host, 'localhost:4567'
    key :basePath, '/'
    key :schemes, ['http']
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # Definir un esquema de ejemplo para los datos del webhook
  swagger_schema :WebhookRequest do
    key :required, [:event, :order_id]
    property :event do
      key :type, :string
    end
    property :order_id do
      key :type, :integer
    end
  end

  # Definir una ruta Swagger para '/webhook'
  swagger_path '/webhook' do
    operation :post do
      key :summary, 'Webhook endpoint'
      key :description, 'Recibe datos de un webhook'
      key :operationId, 'postWebhook'
      key :tags, ['Webhook']

      parameter do
        key :name, :body
        key :in, :body
        key :description, 'Datos del webhook'
        key :required, true
        schema do
          key :'$ref', :WebhookRequest
        end
      end

      response 200 do
        key :description, 'Webhook procesado con éxito'
      end
    end
  end

  # Ruta GET para mostrar un mensaje al acceder desde el navegador
  get '/webhook' do
    "Este endpoint está diseñado para manejar solicitudes POST. Por favor, envía una solicitud POST con los datos necesarios."
  end

  # Ruta POST para procesar webhooks
  post '/webhook' do
    data = JSON.parse(request.body.read)
    puts "Webhook recibido: #{data}"
    status 200
    body "Webhook procesado con éxito"
  end

  # Ruta para obtener el archivo Swagger JSON
  get '/swagger.json' do
    content_type :json
    Swagger::Blocks.build_root_json([WebhookApp]).to_json
  end

  # Ruta para probar la aplicación
  get '/' do
    "Hello, Sinatra!"
  end
end

WebhookApp.run!
