require 'logger'

class SimplerLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)

    status, headers, response = @app.call(env)

    method = env['REQUEST_METHOD']
    uri = env['REQUEST_URI']

    controller = env['simpler.controller']
    action = env['simpler.action']
    template = env['simpler.template_name']

    @logger.info("Request: #{method} #{uri}")
    if controller
      @logger.info("Handler: #{controller.class.name}##{action}")
      @logger.info("Params: #{controller.send(:params)}")
    end
    @logger.info("Response: #{status} [#{headers['Content-Type']}] #{template}")

    [status, headers, response]
  end
end
