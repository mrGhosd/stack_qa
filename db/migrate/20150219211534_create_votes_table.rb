class CreateVotesTable < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :user, index: true
      t.string :vote_type
      t.integer :vote_id, index: true
      t.integer :rate, index: true
    end
  end
end
