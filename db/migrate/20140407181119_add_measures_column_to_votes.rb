class AddMeasuresColumnToVotes < ActiveRecord::Migration
  def up
  	add_column :votes, :measures, :integer, null: true
  end

  def down
  	remove_column :votes, :measures
  end
end
