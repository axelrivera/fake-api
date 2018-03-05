require "yaml"
require "active_support/all"

ASSETS_DIR = "./assets"

helpers do

  def json_response(filename='')
    JSON.parse(json_file(filename)).with_indifferent_access
  end

  def json_file(filename='')
    File.read("#{ASSETS_DIR}/#{filename}.json")
  end

  def yaml_response(filename='')
    begin
      YAML.load(yaml_file(filename)).with_indifferent_access
    rescue
    end
  end

  def yaml_file(filename='')
    File.read("#{ASSETS_DIR}/#{filename}.yml")
  end

  def all_pirates
    json_response("pirates")[:pirates]
  end

  def is_authorization_valid?
    authorization = request.env["HTTP_AUTHORIZATION"]
    halt 401 if authorization.blank?

    token = authorization.split(" ").second

    token == "this-is-a-secure-token"
  end

  def teams(captain=nil)
    yaml_response(captain)
  end

end