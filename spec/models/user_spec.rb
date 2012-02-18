require 'spec_helper'

describe User do
  it { should have_many(:submissions).through(:authorships) }
end
