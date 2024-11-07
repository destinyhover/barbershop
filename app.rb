#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure  do
	$db = SQLite3::Database.new 'barbershop.db'
	$db.execute 'CREATE TABLE "Users" (
	"Id"	INTEGER,
	"Name"	TEXT,
	"Phone"	TEXT,
	"Dateststamp"	TEXT,
	"Barber"	TEXT,
	PRIMARY KEY("Id" AUTOINCREMENT)
);				'

end

get '/' do
	erb "Hello! Welcome to barbershop!"			
end
get '/about' do
	erb :about
end
get '/visit' do
	erb :visit
end
get '/contacts' do
	erb :contacts
end

post '/visit' do
	@name = params[:name]
	@date = params[:date]
	@phone = params[:phone]
	@barber = params[:barber]
	@color=params[:colorpicker]

	hh={:name =>"введите имя", :date=>"введите дату", :phone =>"введите телефон" }

	@error= hh.select{|key,_| params[key]==''}.values.join(", ")
	if @error !=""
		return erb :visit
	end
end





	#f=File.open("./public/user.txt", "a")
	#f.puts "User: #{@name} Phone: #{@phone} barber: #{@barber} date: #{@date} color: #{@color}"
	#f.close



#erb "OK! User: #{@name} Phone: #{@phone} barber: #{@barber} date: #{@date} color: #{@color}"



# post '/contacts'do
# erb "hi"
# end