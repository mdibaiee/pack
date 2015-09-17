class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :url
      t.string :path

      t.timestamps null: false
    end
  end
end
