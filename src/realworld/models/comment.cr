require "crecto"
require "mysql"

require "./user"
require "./article"

module Realworld::Models
  class Comment < Crecto::Model
    schema :comments do
      field :body, String
      belongs_to :user, User
      belongs_to :article, Article
    end

    validate_required [:body, :user_id, :article_id]

    def authored_by?(user : User)
      user_id == user.id
    end

    def posted_in?(article : Article)
      article_id == article.id
    end

  end
end