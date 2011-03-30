require 'codebase_parser'
require 'tinder'

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

    def campfire
      @campfire ||= Tinder::Campfire.new \
        ENV['CAMPFIRE_SUBDOMAIN'],
        :token => ENV['CAMPFIRE_TOKEN'],
        :ssl => ENV['CAMPFIRE_SSL'] && %w(true 1).include?(ENV['CAMPFIRE_SSL'].downcase)
    end

    def campfire_room
      @campfire_room ||= campfire.find_room_by_name ENV['CAMPFIRE_ROOM_NAME']
    end
  end

  get '/' do
    haml :index
  end

  post '/' do
    protected!
    begin
      payload = Payload.new JSON.parse(params[:payload])
      messages = CodebaseParser.parse_notification payload
      messages.each do |message|
        campfire_room.speak message
      end
    rescue Exception => e
      campfire_room.speak "Error processing the payload: #{e.message}"
      campfire_room.paste params[:payload]
      raise
    end
  end

  get '/:stylesheet.css' do |stylesheet|
    scss stylesheet.to_sym
  end
end
