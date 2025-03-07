class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.string :pet_type, null: false                 # 'Cat' or 'Dog'
      t.string :tracker_type, null: false             # 'small', 'medium', 'big'
      t.integer :owner_id, null: false
      t.boolean :in_zone, null: false, default: true
      t.boolean :lost_tracker                         # Only relevant for Cats

      t.timestamps
    end

    # Add index for common query patterns
    add_index :pets, [ :pet_type, :tracker_type, :in_zone ]
  end
end
