#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, params
	db.execute('select * from Barbers where Name=?', [params]).length>0
end

def seed_db db, params
	params.each do |params|
		if !is_barber_exists? db, params
			db.execute('insert into Barbers (Name) VALUES(?)', [params])
		end
	end
end

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
	
	PRIMARY KEY("Id" AUTOINCREMENT)
);				'

seed_db $db, ['Walter White', 'Jessie Pinkman', 'Gus Fring', 'Mike Ermathraut']
end

get '/' do
	erb "Hello! Welcome to barbershop!"			
end
get '/about' do
	erb :about
end
get '/visit' do
	$db.results_as_hash = true
	@showbarbers = $db.execute 'select Name from Barbers' 
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
	$db.results_as_hash = true
	@showbarbers = $db.execute 'select Name from Barbers' 

	

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