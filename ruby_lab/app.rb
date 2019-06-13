require 'sinatra'
require_relative 'lib/trains'
require 'time'
require_relative 'lib/train'
require_relative 'lib/auxiliary_items/user_list'
require_relative 'lib/auxiliary_items/user'

configure do
    enable :sessions
    set :trains, @trains = Trains.new
    @trains.add(Train.new('106', 'Ярославль', 'Москва', '15:00', '19:07', '02.06', '02.06', 800))
    set :cart, Hash.new{|hash, key| hash[key] = Trains.new}
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
    @trains = settings.trains.search(params['from'], params['to'], params['date_from'], 
                             params['date_to'], params['prise_from'], params['prise_unto'])
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
                        params['input5'], params['input6'], params['input7'], params['input8'],)
    @errors = @train.check_fields
    if @errors.empty?
        settings.trains.add(@train)
        redirect('/trains')
    else
        erb :new_train
    end
end

get '/cart' do
    @cart = settings.cart
    erb :cart
end

get '/cart/add/:train_id' do |train_id|
    settings.cart['train_id'] = settings.trains.get(train_id)
    redirect('/cart')
end

get '/cart/del/:train_id' do |train_id|
    settings.cart.delete('train_id')
    redirect('/cart')
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
