require "../base"
require "../../errors"
require "../../models/article"
require "../../models/comment"
require "../../services/repo"
require "../../decorators/comment"

module Realworld::Actions::Comment
  class Create < Realworld::Actions::Base
    include Realworld::Services
    include Realworld::Models

    def call(env)
      user = env.get("auth").as(User)

      slug = env.params.url["slug"]

      article = Repo.get_by(Article, slug: slug)
      raise Realworld::NotFoundException.new(env) if !article

      params = env.params.json["comment"].as(Hash)

      comment = Comment.new
      comment.body = params["body"].as_s
      comment.user = user
      comment.article = article

      changeset = Repo.insert(comment)
      if changeset.valid?
        comment.id = changeset.instance.id
        response = {"comment" => Realworld::Decorators::Comment.new(comment, user)}
        response.to_json
      else
        errors = {"errors" => map_changeset_errors(changeset.errors)}
        raise Realworld::UnprocessableEntityException.new(env, errors.to_json)
      end
    end
  end
end