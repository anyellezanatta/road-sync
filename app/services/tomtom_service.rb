require 'httparty'

class TomtomService
  include HTTParty
  include ERB::Util
  base_uri 'https://api.tomtom.com'

  def initialize(api_key)
    @api_key = api_key
  end

  def calculate_route(start_point, end_point)
    options = {
      query: {
        apiVersion: 2,
        key: @api_key,
        traffic: "historical"
      }
    }
    response = self.class.get("/maps/orbis/routing/calculateRoute/#{start_point}:#{end_point}/json", options)
    response["routes"].present? ? response["routes"].first["legs"].first["points"] : []
  end

  def geocode_endpoints(address)
    options = {
      query: {
        apiVersion: 1,
        key: @api_key
      }
    }
    response = self.class.get("/maps/orbis/places/geocode/#{url_encode(address)}.json", options)
    response["results"].first["position"] if response["results"].present?
  end
end
