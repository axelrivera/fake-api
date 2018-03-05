require "sinatra"
require "sinatra/namespace"
require "json"
require "active_support/all"
require "rack/contrib"
require "will_paginate/array"
require_relative "helpers.rb"

use Rack::PostBodyContentTypeParser

configure do
  $stdout.sync = true # Disable console buffering in Foreman
end

before do
  content_type "application/json"
  puts "params: #{params}"
end

namespace "/api" do

  post "/register" do
    halt 400 if params[:full_name].blank?
    halt 400 if params[:email].blank?
    halt 400 if params[:password].blank?

    halt 400, { message: "invalid email"}.to_json if params[:email] =~ URI::MailTo::EMAIL_REGEXP
    halt 400, { message: "password must be at least 8 characters long"}.to_json if params[:password].count < 8

    { token: "this-is-a-secure-token" }.to_json
  end

  post "/login" do
    halt 400 if params[:email].blank?
    halt 400 if params[:password].blank?

    halt 500 if params[:email] == "error"
    halt 401 if params[:password] == "password"

    { token: "this-is-a-secure-token" }.to_json
  end

  get "/pirates" do
    is_authorization_valid?

    page = params[:page] || 1

    pirates = all_pirates.paginate(page: page, per_page: 25)
    { pirates: pirates, per_page: 25, total_pages: all_pirates.count }.to_json
  end

  get "/team" do
    is_authorization_valid?

    halt 400, { message: "captain cannot be empty" }.to_json if params[:captain].blank?
    
    team = teams(params[:captain])
    halt 404, { message: "team not found" }.to_json if team.blank?

    team.to_json
  end

end