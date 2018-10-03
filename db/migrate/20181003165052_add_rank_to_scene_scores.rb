class AddRankToSceneScores < ActiveRecord::Migration[5.1]
    def change
      add_column :scene_scores, :rank, :integer, default: 0, null: false
    end
end
