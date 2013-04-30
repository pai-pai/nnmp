class ChangeCommentFieldType < ActiveRecord::Migration
    def up
        change_column :votes, :comment, :text
    end

    def down
        change_column :votes, :comment, :string
    end
end
