# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "erb"
require "csv"

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

delete "/delete" do
end
