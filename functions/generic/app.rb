# require 'httparty'
require 'json'
require 'config/application'

class LambdaHandler
  def self.handle(event:, context:)
    # Parameters
    # ----------
    # event: Hash, required
    #     API Gateway Lambda Proxy Input Format
    #     Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format

    # context: object, required
    #     Lambda Context runtime methods and attributes
    #     Context doc: https://docs.aws.amazon.com/lambda/latest/dg/ruby-context.html

    # Loads configurantion file
    Config::Application.load

    {
      statusCode: 200,
      body: {
        message: "Hello World!",
        context: context,
        event: event
        # location: response.body
      }.to_json
    }
  end
end
