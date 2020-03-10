# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
require "geocoder"
account_sid = AC0c9a0670fb6c0165b8f10fdd1797a49f
auth_token = d29cd2956ee05d29cbd72136a70e8ebe
client = Twilio::REST::Client.new(account_sid, auth_token)
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

client.messages.create(
  from: "+17724105382", 
  to: "+16084383038",
  body: "Hey KIEI 451!"
)

events_table = DB.from(:events)
rsvps_table = DB.from(:rsvps)
