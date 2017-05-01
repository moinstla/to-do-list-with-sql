require 'sinatra'
require 'sinatra/reloader'
require './lib/task'
require './lib/list'
require 'pry'
require 'pg'

also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "to_do_test"})

get('/') do
  erb(:index)
end

get("/lists/new") do
  erb(:list_form)
end

post("/lists") do
  name = params.fetch("name")
  list = List.new({:name => name, :id => nil})
  list.save
  erb(:success)
end

get("/lists") do
  @lists = List.all
  erb(:lists)
end

get("/lists/:id") do
  @list = List.find(params.fetch("id").to_i)
  erb(:list)
end

post("/tasks") do
  description = params.fetch("description")
  list_id = params.fetch("list_id").to_i
  task = Task.new({:description => description, :list_id => list_id})
  task.save
  erb(:success)
end
