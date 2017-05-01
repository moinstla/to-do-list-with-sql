require 'sinatra'
require 'sinatra/reloader'
require './lib/task'
require 'pry'
require 'pg'

also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "to_do"})

get('/') do
  erb(:index)
end
