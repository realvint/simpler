require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if text_plain
        ERB.new(text_plain).result(binding)
      else
        @env['simpler.template_name'] = template_name
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end
    end

    private

    def text_plain
      @env['simpler.text_plain']
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def template_name
      path = [controller.name, action].join('/')
      "#{path}.html.erb"
    end

  end
end
