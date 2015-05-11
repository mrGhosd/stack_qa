class AddVoteTypeToVotetable < ActiveRecord::Migration
  def change
    add_column :votes, :vote_value, :string
  end
end
