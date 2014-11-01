require 'open-uri'
require 'json'

class ForecastsController < ApplicationController

  def location
    # Prepare user input for URL
    url_safe_address = URI.encode(params[:address])
    # @the_address = url_safe_address
    # @the_address = url_safe_address.gsub('+',' ')

    # Get coordinates from address
    url_of_data_we_want = "http://maps.googleapis.com/maps/api/geocode/json?address=#{url_safe_address}"
    raw_data = open(url_of_data_we_want).read
    parsed_data =JSON.parse(raw_data)
    @the_latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    @the_longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]
    @the_address = parsed_data["results"][0]["formatted_address"]

    # Get weather from coordinates
    url_of_data_we_want = "https://api.forecast.io/forecast/fbd7471ca1c0c6d188c8711dab2a54ce/#{@the_latitude},#{@the_longitude}"
    raw_data = open(url_of_data_we_want).read
    parsed_data =JSON.parse(raw_data)

    @the_temperature  = parsed_data["currently"]["temperature"]
    @the_hour_outlook = parsed_data["hourly"]["data"][0]["summary"]
    @the_day_outlook  = parsed_data["daily"]["data"][0]["summary"]

    render 'location'
  end

end
