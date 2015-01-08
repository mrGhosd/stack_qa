require 'rails_helper'

describe Comment do
  it { should belongs_to :user }
  it { should belongs_to :question }
end