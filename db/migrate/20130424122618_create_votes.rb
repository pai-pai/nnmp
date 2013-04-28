class CreateVotes < ActiveRecord::Migration
    def up
        create_table :votes do |t|
            t.references :user
            t.references :candidate
            t.string :comment
            t.string :voter_fio
            t.string :voter_phone

            t.timestamps
        end

        add_index :votes, :user_id
        add_index :votes, :candidate_id
    end

    def down
        remove_index :votes, :user_id
        remove_index :votes, :candidate_id
        drop_table :votes
    end
end
