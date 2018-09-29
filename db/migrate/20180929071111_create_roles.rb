class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.references :person
      t.references :movie

      t.timestamps
    end
  end
end
