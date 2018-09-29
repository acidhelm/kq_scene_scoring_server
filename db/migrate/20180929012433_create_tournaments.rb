class CreateTournaments < ActiveRecord::Migration[5.1]
  def change
    create_table :tournaments do |t|
      t.string :title
      t.string :slug
      t.string :subdomain
      t.boolean :complete
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
