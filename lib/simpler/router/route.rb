module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && parse_path(path)
      end

      private

      def parse_path(path)
        router_components = path_components(@path)
        request_components = path_components(path)

        return false if (request_components.size unless request_components.nil?) != router_components.size

        router_components.each_with_index do |component, index|
          if param?(component)
            add_params(component, request_components[index])
          else
            return false unless component == request_components[index]
          end
        end
      end

      def param?(component)
        component.start_with?(':')
      end

      def add_params(param, value)
        param = param.delete(':').to_sym
        @params[param] = value
      end

      def path_components(path)
        path.split('/').reject!(&:empty?)
      end

    end
  end
end
