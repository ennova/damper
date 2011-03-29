class Damper < Sinatra::Application
  get '/' do
    haml :index
  end

  post '/' do

  end

  get '/:stylesheet.css' do |stylesheet|
    scss stylesheet.to_sym
  end
end
