require 'httparty'

class TomTomService
  include HTTParty
  base_uri 'https://api.tomtom.com'

  def initialize(api_key)
    @api_key = api_key
  end

  def calculate_route(start_point, end_point)
    options = {
      query: {
        apiVersion: 2,
        key: @api_key
      }
    }
    self.class.get("/maps/orbis/routing/calculateRoute/#{start_point}:#{end_point}/json", options)
  end
end
