#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'uri'
require 'rexml/document'

CLOUDINESS = {0 => 'Ясно', 1 => 'Малооблачно', 2 => 'Облачно', 3 => 'Пасмурно'} uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/86.xml")

response = Net::HTTP.get_response(uri)


doc = REXML::Document.new(response.body)


city_name = URI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])

current_forcast = doc.root.elements['REPORT/TOWN'].elements.to_a[0]

min_temp = current_forcast.elements['TEMPERATURE'].attributes['min']
max_temp = current_forcast.elements['TEMPERATURE'].attributes['max']

max_wind = current_forcast.elements['WIND'].attributes['max']

clouds_index = current_forcast.elements['PHENOMENA'].attributes['cloudiness'].to_i
clouds = CLOUDINESS[clouds_index]

puts "Погода в #{city_name} сегодня:"
puts "Температура: от #{min_temp} до #{max_temp} °C"
puts "Ветер до #{max_wind} м/с"
puts clouds

