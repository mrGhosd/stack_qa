require 'rails_helper'

describe Question do
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :text }
  it { should have_many :answers }
  it { should belong_to(:user) }
  it { should belong_to(:category) }
  it { should have_db_index :title }
  it { should have_db_index :is_closed }
end