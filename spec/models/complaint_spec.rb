require 'rails_helper'

describe Complaint do
  it { should belong_to :user }
  it { should belong_to :complaintable }
end