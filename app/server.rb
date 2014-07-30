require 'data_mapper'
require 'sinatra'
require 'rack-flash'
require 'sinatra/partial'
require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'
require_relative './views/helpers/helpers'
require_relative 'data_mapper_setup'

require_relative './views/controllers/users'
require_relative './views/controllers/sessions'
require_relative './views/controllers/links'
require_relative './views/controllers/tags'
require_relative './views/controllers/application'

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
set :partial_template_engine, :erb


