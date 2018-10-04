# frozen_string_literal: true

class SceneScore < ApplicationRecord
    belongs_to :tournament

    validates :rank, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    scope :alphabetical_order, -> { order(name: :asc) }
    scope :score_order, -> { order(score: :desc).alphabetical_order }
    scope :rank_order, -> { order(rank: :asc).alphabetical_order }
end
