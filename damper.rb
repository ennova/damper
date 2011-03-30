require 'codebase_parser'

class Damper < Sinatra::Application
  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials == [ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD']]
    end
  end

  get '/' do
    haml :index
  end

  post '/' do
    protected!
  end

  get '/:stylesheet.css' do |stylesheet|
    scss stylesheet.to_sym
  end
end
