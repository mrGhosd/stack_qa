require 'rails_helper'

describe Answer do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many :comments }
  it { should have_many :complaints }
end