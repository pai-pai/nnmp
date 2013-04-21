class CreateUsers < ActiveRecord::Migration
    def up
        create_table :users do |t|
            t.string :email
            t.string :password_hash
            t.string :remember_token
            t.boolean :admin, :default => false

            t.timestamps
        end

        add_index :users, :email
        add_index :users, :remember_token
    end

    def down
        drop_table :users

        remove_index :users, :email
        remove_index :users, :remember_token
    end
end
