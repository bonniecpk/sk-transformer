require 'csv'
require 'json'
require 'monetize'
require 'pry'

Dir["{lib}/**/*.rb"].each do |file|
  require_relative file
end
