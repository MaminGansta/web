# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Application', type: :feature do
  before(:example) do
    Capybara.app = Sinatra::Application.new
  end

  it 'Should check /' do
    visit('/')
    expect(page).to have_content('Привет, пользователь')
  end

  it 'Should check /tickets' do
    visit('/tickets')
    fill_in('from', with: 'Ярославль')
    fill_in('to', with: 'Москва')
    fill_in('date_from', with: '19.06')
    fill_in('date_to', with: '19.06')
    fill_in('price_from', with: '500')
    fill_in('price_unto', with: '1000')
    click_on('Искать')
    expect(page).to have_content('Ярославль')
    expect(page).to have_content('Москва')
  end

  it 'Check /options' do
    visit('/options')
    click_on('Показать')
    expect(page).to have_content('Тутаев')
    choose('exampleRadios2')
    click_on('Показать')
    expect(page).to have_content('Ярославль')
    expect(page).to have_content('Тутаев')
    expect(page).to have_content('Москва')
    choose('exampleRadios3')
    fill_in('input1', with:'Ярославль')
    fill_in('input2', with:'19.6')
    click_on('Показать')
    expect(page).to have_content('3')
  end

  it 'Ckeck login' do
    visit('/login')
    expect(page).to have_content('вход')
    click_on('Зарегистрировать нового пользователя')
    expect(page).to have_content('Регистрация')
    fill_in('user', with: 'admin')
    fill_in('password', with: '1234')
    click_on('Добавить пользователя')
    expect(page).to have_content('Такое имя уже существует')
    fill_in('user', with: 'name')
    fill_in('password', with: '1234')
    click_on('Добавить пользователя')
    fill_in('user', with: 'name1')
    fill_in('password', with: '1234')
    click_on('Войти')
    fill_in('user', with: 'name')
    fill_in('password', with: '1234')
    click_on('Войти')
    expect(page).to have_content("Вы вошли под ником: name")
    click_on('выход')
    expect(page).not_to have_content('Вы вошли под ником: name')
  end

  it 'Ckeck add/del trains' do
    visit('/login')
    fill_in('user', with: 'admin')
    fill_in('password', with: 'admin')
    click_on('Войти')
    click_on('Поезда')
    click_on('Добавить')
    fill_in('input1', with: '107')
    fill_in('input2', with: 'Воронеж')
    fill_in('input3', with: 'Москва')
    fill_in('input4', with: '20.6')
    fill_in('input5', with: '22.6')
    fill_in('input6', with: '12:43')
    fill_in('input7', with: '16:15')
    fill_in('input8', with: '2400')
    click_on('Добавить')
    visit('/trains')
    expect(page).to have_content('Воронеж')
    find_link('Удалить', match: :first).click
    expect(page).not_to have_content('Воронеж')
  end

  it 'Check cart' do
    visit('/login')
    fill_in('user', with: 'admin')
    fill_in('password', with: 'admin')
    click_on('Войти')
    visit('/tickets')
    find_link('Купить', match: :first).click
    visit('/cart')
    expect(page).to have_content('Ярославль')
    find_link('Удалить', match: :first).click
    expect(page).not_to have_content('Ярославль')
  end

end