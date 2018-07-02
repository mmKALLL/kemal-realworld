require "../base"
require "../../errors"
require "../../models/user"
require "../../models/following"
require "../../services/repo"
require "../../decorators/profile"

module Realworld::Actions::Profile
  class Unfollow < Realworld::Actions::Base
    include Realworld::Services
    include Realworld::Models

    def call(env)
      user = env.get("auth").as(Realworld::Models::User)
      
      profile_owner = Repo.get_by(User, username: env.params.url["username"])
      raise Realworld::NotFoundException.new(env) if !profile_owner
      
      query = Repo::Query.where(follower_user_id: user.id, followed_user_id: profile_owner.id)
      changeset = Repo.delete_all(Following, query)
      
      user = Repo.get!(User, user.id, Repo::Query.preload([:followed_users]))

      response = {"profile" => Realworld::Decorators::Profile.new(profile_owner, user)}
      response.to_json
    end
  end
end