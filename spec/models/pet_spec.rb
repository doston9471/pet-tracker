require 'rails_helper'

RSpec.describe Pet, type: :model do
  let(:valid_attributes) do
    {
      pet_type: 'Cat',
      tracker_type: 'small',
      owner_id: 1,
      in_zone: false,
      lost_tracker: false
    }
  end

  it 'validates with correct attributes' do
    expect(Pet.new(valid_attributes)).to be_valid
  end

  describe 'Validations' do
    it { should validate_presence_of(:pet_type) }
    it { should validate_inclusion_of(:pet_type).in_array(%w[Cat Dog]) }
    it { should validate_presence_of(:tracker_type) }
    it { should validate_presence_of(:owner_id) }
    it { should validate_numericality_of(:owner_id).only_integer }

    context 'In Zone' do
      it { should allow_values(true, false).for(:in_zone) }
      it { should_not allow_value(nil).for(:in_zone) }
    end

    context 'when Cat' do
      let(:pet) { Pet.new(valid_attributes) }

      it 'validates tracker type' do
        pet.tracker_type = 'invalid'
        pet.valid?
        expect(pet.errors[:tracker_type]).to include('must be small or big for Cats')
      end

      it 'requires lost_tracker' do
        pet.lost_tracker = nil
        pet.valid?
        expect(pet.errors[:lost_tracker]).to include('must be present for Cats')
      end
    end

    context 'when Dog' do
      let(:pet) { Pet.new(valid_attributes.merge(pet_type: 'Dog', tracker_type: 'medium', lost_tracker: nil)) }

      it 'validates tracker type' do
        pet.tracker_type = 'invalid'
        pet.valid?
        expect(pet.errors[:tracker_type]).to include('must be small, medium, or big for Dogs')
      end

      it 'forbids lost_tracker' do
        pet.lost_tracker = true
        pet.valid?
        expect(pet.errors[:lost_tracker]).to include('must be blank for Dogs')
      end
    end
  end
end
