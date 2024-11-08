#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure  do
	$db = SQLite3::Database.new 'barbershop.db'
	$db.execute 'CREATE TABLE IF NOT EXISTS "Users" (
	"Id"	INTEGER,
	"Name"	TEXT,
	"Phone"	TEXT,
	"Dateststamp"	TEXT,
	"Barber"	TEXT,
	"Color" TEXT,
	PRIMARY KEY("Id" AUTOINCREMENT)
);				'
$db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" (
	"Id"	INTEGER,
	"Name"	TEXT,
	"Phone"	TEXT,
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

get '/showusers' do
	$db.results_as_hash = true
	@showusers = $db.execute 'select*from Users order by id desc --' 
	erb :showusers

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

	$db.execute 'insert into Users (Name, Phone, Dateststamp, Barber, Color) values (?,?,?,?,?)', [@name, @phone, @date, @barber, @color]



erb "OK! User: #{@name} Phone: #{@phone} barber: #{@barber} date: #{@date} color: #{@color}"
end




# post '/contacts'do
# erb "hi"
# end