class Tournament < ApplicationRecord
    belongs_to :user
    has_many :scene_scores, dependent: :destroy
    validates :slug, presence: true
    validates :title, presence: true
end
