# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "erb"
require "csv"

enable :method_override

get "/" do
  @memo_data = CSV.read("files/memo.csv", headers: true)
  erb :index
end

get "/new" do
  erb :new
end

post "/new" do
  CSV.open("files/memo.csv", "a") do |csv|
    csv << [params[:id], params[:title], params[:content]]
  end
  erb :new
  redirect "/"
end

get "/show/:id" do
  id = params[:id]
  CSV.read("files/memo.csv", headers: true).each do |row|
    if row.field("id") == id
      @memo = row
    end
  end
  erb :show
end

patch "/edit" do
end

delete "/memo/:id" do
  id = params[:id]
  csv_table = CSV.table("files/memo.csv", headers: true)
  csv_table.by_row!
  csv_table.delete_if { |row| row.field?(id) }
  csv_table.to_a
  CSV.open("files/memo.csv", "w", headers: true) do |csv|
    csv_table.each do |row|
      csv.puts row
    end
  end

  redirect "/"
  erb :index
end
