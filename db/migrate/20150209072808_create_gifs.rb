class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.string :gif_url
      t.references :user
      t.string :title

      t.timestamps
    end
  end
end
