#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'uri'
require 'rexml/document'
require 'sinatra/activerecord'

CITIES = {'Тольятти' => '86', 'Москва' => '37', 'Санкт-Петербург' => '69', 'Нижний Новгород' => '120', 'Мурманск' => '113', 'Адлер' => '2879'}.freeze

get '/' do
  @cities = CITIES
  erb :city
end

post '/city' do
  CLOUDINESS = {0 => 'Ясно', 1 => 'Малооблачно', 2 => 'Облачно', 3 => 'Пасмурно'}

  @city = params[:city]
  if @city.length <= 0
      @error = 'Введите ваш город'
    return erb :city
  end

  @x = CITIES[@city]
  uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{@city}.xml")

  response = Net::HTTP.get_response(uri)

  doc = REXML::Document.new(response.body)


  @city_name = URI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])

  @current_forcast = doc.root.elements['REPORT/TOWN'].elements.to_a[0]

  @min_temp = @current_forcast.elements['TEMPERATURE'].attributes['min']
  @max_temp = @current_forcast.elements['TEMPERATURE'].attributes['max']

  @max_wind = @current_forcast.elements['WIND'].attributes['max']

  @clouds_index = @current_forcast.elements['PHENOMENA'].attributes['cloudiness'].to_i
  @clouds = CLOUDINESS[@clouds_index]
  erb :index
end



