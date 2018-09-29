class Tournament < ApplicationRecord
    belongs_to :user
    validates :slug, presence: true
    validates :title, presence: true
end
