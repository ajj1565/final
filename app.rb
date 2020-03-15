# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
require "geocoder"
# put your API credentials here (found on your Twilio dashboard)
account_sid = ENV["TWILIO_ACCOUNT_SID"]
auth_token = ENV["TWILIO_AUTH_TOKEN"]
client = Twilio::REST::Client.new(account_sid, auth_token)
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

bars_table = DB.from(:bars)
ratings_table = DB.from(:ratings)
users_table = DB.from(:users)

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do
    @bars = bars_table.all.to_a
    view "homepage"
end

get "/bars/:id" do
    @bar = bars_table.where(id: params[:id]).to_a[0]
    @ratings = ratings_table.where(bar_id: @bar[:id])
    @users_table = users_table

    results = Geocoder.search(@bar[:location])
    lat_long = results.first.coordinates
    @lat_long = "#{lat_long[0]} #{lat_long[1]}"

    ratingscount = ratings_table.where(bar_id: @bar[:id]).count
    if ratingscount == 0 then
        @staffrating = 0
        @environmentrating = 0
        @drinksrating = 0
        @overallrating = 0
    else
        staffrating = ratings_table.where(bar_id: @bar[:id]).sum(:staff)
        environmentrating = ratings_table.where(bar_id: @bar[:id]).sum(:environment)
        drinksrating = ratings_table.where(bar_id: @bar[:id]).sum(:drinks)
        overallrating=staffrating+environmentrating+drinksrating
        @staffrating = staffrating / (ratingscount/3)
        @environmentrating = environmentrating / (ratingscount/3)
        @drinksrating = drinksrating / (ratingscount/3)
        @overallrating = overallrating / ratingscount
    end
    view "bar"
end

get "/users/new" do
    view "create_user"
end

post "/users/create" do
    hashed_password = BCrypt::Password.create(params["password"])
    users_table.insert(username: params["username"], 
        name: params["name"],
        phone: params["phone"],
        email: params["email"], 
        password: hashed_password
        )
    view "create_user_confirm"
end

get "/logins/new" do
    view "login"
end

post "/logins/create" do
    user = users_table.where(username: params["username"]).to_a[0]
    if user && BCrypt::Password::new(user[:password]) == params["password"]
        session["user_id"] = user[:id]
        @current_user = user
        view "login_confirm"
    else
        view "login_fail"
    end
end