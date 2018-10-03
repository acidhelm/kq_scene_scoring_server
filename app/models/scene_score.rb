class SceneScore < ApplicationRecord
    belongs_to :tournament

    scope :alphabetical_order, -> { order(name: :asc) }
    scope :score_order, -> { order(score: :desc).alphabetical_order }
    scope :rank_order, -> { order(rank: :asc).alphabetical_order }
end
