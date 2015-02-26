class CreateUserStatistic < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.belongs_to :user
      t.integer :rate, default: 0
      t.integer :answers_count, default: 0
      t.integer :questions_positive_rate_count, default: 0
      t.integer :questions_negative_rate_count, default: 0
      t.integer :answers_positive_rate_count, default: 0
      t.integer :answers_negative_rate_count, default: 0
      t.integer :helpfull_answers_count, default: 0
      t.integer :first_answers_count, default: 0
      t.integer :first_self_answers_count, default: 0
      t.integer :self_answers_count, default: 0
      t.timestamps
    end
  end
end
