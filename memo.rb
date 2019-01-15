# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "erb"
require "csv"

def parse_memo_related_with_id
  id = params[:id]
  CSV.read("files/memo.csv", headers: true).each do |row|
    if row.field("id") == id
      @memo = row
    end
  end
end

def recreate_csv_file(csv_table)
  header = %w(id title content)
  CSV.open("files/memo.csv", "w") do |csv|
    csv << header
    csv_table.each do |row|
      csv.puts row
    end
  end
end

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

get "/:id" do
  parse_memo_related_with_id
  erb :show
end

get "/edit/:id" do
  parse_memo_related_with_id
  erb :edit
end

patch "/edit_memo/:id" do
  id = params[:id]
  csv_table = CSV.table("files/memo.csv", headers: true)
  csv_table.each do |row|
    if row[:id] == id
      row[:title] = params[:title]
      row[:content] = params[:content]
    end
  end

  recreate_csv_file(csv_table)
  redirect "/"
  erb :index
end

delete "/memo/:id" do
  id = params[:id]
  csv_table = CSV.table("files/memo.csv", headers: true)
  csv_table.by_row!
  csv_table.delete_if { |row| row.field?(id) }

  recreate_csv_file(csv_table)
  redirect "/"
  erb :index
end
