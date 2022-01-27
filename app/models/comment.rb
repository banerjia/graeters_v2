class Comment < ApplicationRecord
    default_scope { order(created_at: :desc).limit(20) }

    belongs_to :commentable, polymorphic: true, counter_cache: true
end
