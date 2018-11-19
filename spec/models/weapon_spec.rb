require 'rails_helper'

RSpec.describe Weapon, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:attack_points) }
  it { should validate_presence_of(:durability) }
  it { should validate_presence_of(:price) }

  it { should validate_uniqueness_of(:name) }
end
