# frozen_string_literal: true

class Tournament < ApplicationRecord
    belongs_to :user
    has_many :scene_scores, dependent: :destroy
    validates :slug, presence: true
    validates :title, presence: true

    def challonge_url
        "https://#{"#{subdomain}." if subdomain.present?}challonge.com/#{slug}"
    end
end
