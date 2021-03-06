require "crecto"
require "mysql"

module Realworld::Services
  class Repo
    extend Crecto::Repo

    Query = Crecto::Repo::Query
    Multi = Crecto::Repo::Multi

    config do |conf|
      conf.adapter = Crecto::Adapters::Mysql
      conf.database = ENV["MYSQL_DATABASE"]
      conf.hostname = ENV["MYSQL_HOSTNAME"]
      conf.username = ENV["MYSQL_USERNAME"]
      conf.password = ENV["MYSQL_PASSWORD"]
      conf.port     = ENV["MYSQL_PORT"].to_i
    end
  end
end