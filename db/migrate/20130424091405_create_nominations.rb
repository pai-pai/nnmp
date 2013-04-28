class CreateNominations < ActiveRecord::Migration
    def up
        create_table :nominations do |t|
            t.string :name
            t.string :desc

            t.timestamps
        end
    end

    def down
        drop_table :nominations
    end
end
