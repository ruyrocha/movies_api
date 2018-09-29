class CreateAliases < ActiveRecord::Migration[5.2]
  def change
    create_table :aliases do |t|
      t.string :name
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
