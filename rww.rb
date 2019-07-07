#!/usr/bin/env ruby

# Weather Widget for Ruby
# Created by Dan Nichols (dgn@problemsolvent.net)
# Retrieves and displays current conditions for Los Angeles, CA, USA
# Source data is provided by https://openweathermap.org/current
# A valid API is required for successful operation.

#include dependencies
require 'artii'
require 'date'
require 'json'
require 'net/http'
require 'tzinfo'

#configure API settings
api_key = 'be329f4a5216b0af499e252f075dd930'
location_id = '5368361'

#configure timezone and timestamp format
timestamp_format = '%H:%M:%S %Z'
timezone_id = 'America/Los_Angeles'

#request current weather data
weather = JSON.parse(Net::HTTP.get(URI('https://api.openweathermap.org/data/2.5/weather?id=' + location_id + '&appid=' + api_key)))

#create timezone and ASCII art objects
tz = TZInfo::Timezone.get(timezone_id)
ascii = Artii::Base.new #:font => 'slant'

#convert wind direction
direction = case weather['wind']['deg']
 when 11.25..33.74 then "NNE"
 when 33.75..56.24 then "NE"
 when 56.25..78.74 then "ENE"
 when 78.75..101.24 then "E"
 when 101.25..123.74 then "ESE"
 when 123.75..146.24 then "SE"
 when 146.25..168.74 then "SSE"
 when 168.75..191.24 then "S"
 when 191.25..213.74 then "SSW"
 when 213.75..236.24 then "SW"
 when 236.25..258.74 then "WSW"
 when 258.75..281.24 then "W"
 when 281.25..303.74 then "WNW"
 when 303.75..326.24 then "NW"
 when 326.25..348.74 then "NNW"
 else "N"
end

#define temperature conversion methods
def celsius(ks)
 c = (ks.to_f - 273.15).to_i
end
def fahrenheit(ks)
 f = ((9.to_f / 5.to_f) * (ks.to_f - 273.15) + 32).to_i
end
def fc_temps(t, ks)
 temps = t + fahrenheit(ks).to_s + " F / " + celsius(ks).to_s + " C "
end

#generate output
puts("\n",
 ascii.asciify(weather['weather'][0]['main'] + "  " + fahrenheit(weather['main']['temp']).to_s + " F"),
 ("Conditions for " + weather['name'] + " as of " + tz.now.strftime("%Y-%m-%d " + timestamp_format) + "\n"),
 (fc_temps("Now: ", weather['main']['temp']) + "| " + fc_temps("High: ", weather['main']['temp_max']) + "| " + fc_temps("Low: ", weather['main']['temp_min'])),
 ("Wind: " + (weather['wind']['speed'].to_f*2.236936).round(1).to_s + " mph " + direction + " | Humidity: " + weather['main']['humidity'].to_s + "% | Pressure: " + weather['main']['pressure'].to_s + " hPa\n"),
 ("Sunrise: " +  tz.to_local(DateTime.strptime(weather['sys']['sunrise'].to_s, "%s")).strftime(timestamp_format) + " | Sunset: " + tz.to_local(DateTime.strptime(weather['sys']['sunset'].to_s, "%s")).strftime(timestamp_format) + "\n")
)

#success
exit(status=true)
