class SceneScore < ApplicationRecord
    belongs_to :tournament

    scope :ranked_order, -> { order(score: :desc, name: :asc) }
end
