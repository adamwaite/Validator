require 'sinatra'
require 'json'

# returns JSON "true" if the validated instance does not contain the word "invalid", "false" otherwise.
post '/validate', provides: :json do
  pass unless request.accept? 'application/json'
  json_params = JSON.parse request.body.read
	is_valid = (json_params["instance"].nil?) ? false : !(json_params["instance"].include? "invalid")
	puts "Input valid - returning JSON true" if is_valid
  puts "Input invalid - returning JSON false" unless is_valid
  content_type :json
	is_valid.to_json
end