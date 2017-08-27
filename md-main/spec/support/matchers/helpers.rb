module MatchersHelpers
  def parsed_response
    JSON.parse(response.body).symbolize_keys
  end
end
