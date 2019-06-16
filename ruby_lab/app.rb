require 'sinatra'
require_relative 'lib/trains'
require 'time'
require_relative 'lib/train'
require_relative 'lib/auxiliary_items/user_list'
require_relative 'lib/auxiliary_items/user'
require_relative 'lib/auxiliary_items/checker'
require_relative 'lib/auxiliary_items/search'

configure do
    enable :sessions
    set :trains, @trains = Trains.new
    @trains.add(Train.new('106', 'Ярославль', 'Москва', '02.06', '02.06', '15:00', '19:07', '800'))
    set :shopping_cart, Hash.new{|hash, key| hash[key] = Trains.new}
    set :user_list, @user_list = UserList.new
    @user_list.add(User.new('admin', 'admin'))
end

before do
    user_id = session[:user_id]
    @user = settings.user_list.get(user_id)
end

get '/' do
    erb :main
end

get '/tickets' do
    @time = Time.new
    @trains = settings.trains
    erb :tickets
end

post '/tickets' do
    @time = Time.new
    @errors = Checker.check_ticket_search_validaty(params['from'], params['to'], params['date_from'], 
                                           params['date_to'], params['price_from'], params['price_unto'])
    if !@errors
        @trains = Search.search_tickets(settings.trains, params['from'], params['to'], params['date_from'], 
                             params['date_to'], params['price_from'], params['price_unto'])
    end
    erb :tickets
end

get '/trains' do
    @trains = settings.trains
    erb :trains
end

get '/trains/new' do
    erb :new_train
end

get '/trains/del/:train_id' do |train_id|
    settings.trains.del(train_id)
    redirect('/trains')
end

post '/trains/new' do
    @train = Train.new(params['input1'], params['input2'], params['input3'], params['input4'],
                        params['input5'], params['input6'], params['input7'], params['input8'])
    @errors = Checker.check_new_train_fields(params['input1'], params['input2'], params['input3'], params['input4'],
                                params['input5'], params['input6'], params['input7'], params['input8']) 
    p params
    p @errors
    if !@errors
        settings.trains.add(@train)
        redirect('/trains')
    else
        erb :new_train
    end
end

get '/cart' do
    @cart = settings.shopping_cart[@user]
    @cart.each do |train|
        @cart.del(train.id) if !settings.trains.has?(train.id)
    end
    settings.shopping_cart[@user] = @cart
    erb :cart
end

get '/cart/add/:train_id' do |train_id|
    cart = settings.shopping_cart[@user] 
    cart.add(settings.trains.get(train_id))
    redirect('/cart')
end

get '/cart/del/:train_id' do |train_id|
    cart = settings.shopping_cart[@user]
    cart.del(train_id)
    redirect('/cart')
end

get '/options' do
    erb :options
end

post '/options' do
    p params
    if params['radio'] == 'option1'
        @citys = Search.search_dead_end(settings.trains)
    end
    if params['radio'] == 'option2'
        @citys = Search.citys_wits_trains(settings.trains)
    end
    if params['radio'] == 'option3'
        @errors = Checker.ckeck_option_fields(params['input1'], params['input2'])
        break if @errors
        @railways_in_city = Search.how_railways_need(settings.trains, params['input1'], params['input2'])
    end
    @city = @railways_in_city
    erb :options
end

get '/login' do
    erb :login_form
end

get '/unlogin' do
    session[:user_id] = nil
    redirect back
end
  
post '/login' do
    name = params['user']
    password = params['password']
    users = settings.user_list

    if users.has_user?(User.new(name, password))
        session[:user_id] = users.get_id(User.new(name, password))
        redirect('/tickets')
    end
    @errors = 'Такая пара имени пользователя и пароля не найдены'
    erb :login_form
end
  
get '/user/new' do
    erb :user_form
end
  
post '/user/new' do
    logger.info(params)
    users = settings.user_list

    user = User.new(params['user'], params['password'])
    if  !users.has_nickname?(user)
        settings.user_list.add(user)
        redirect to('/login')
    end
    @errors = 'Такое имя уже существует'
    erb :user_form
end
