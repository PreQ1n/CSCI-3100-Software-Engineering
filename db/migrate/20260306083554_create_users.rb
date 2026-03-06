class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :password_digest, null: false
      t.string :email, null:false
      t.string :faculty, default: "Undeclared"
      t.string :major, default: "Undeclared"
      t.string :college, default: "Undeclared"

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
