require 'httparty'

class Zippopotamus
  BASE_URL = "http://api.zippopotam.us"
  attr_reader :country, :zipcode

  def initialize(zipcode, country='us')
    @country = country
    @zipcode = zipcode
  end

  def run
    raise ArgumentError, 'You must provide a zipcode' if @zipcode.blank?

    begin
      response = HTTParty.get("#{BASE_URL}/#{@country}/#{@zipcode}")

      if response.code == 200
        return Zippo.build_with_json(JSON.parse(response.body))
      elsif response.code == 404
        return {}
      else
        Rails.logger.error("Failed response for zip: #{@zipcode} : #{response.response}")
        return { error: "Something has gone wrong"}
      end
    rescue HTTParty::Error, StandardError => ex
      Rails.logger.error("Failed response for zip: #{@zipcode} : #{ex.message}")
      return { error: "Something has gone wrong"}
    end
  end
end
