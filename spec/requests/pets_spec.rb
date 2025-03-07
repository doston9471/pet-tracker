require 'rails_helper'

RSpec.describe 'Pets API', type: :request do
  describe 'GET /api/pets' do
    let!(:pets) do
      [
        Pet.create!(pet_type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: false, lost_tracker: false),
        Pet.create!(pet_type: 'Dog', tracker_type: 'big', owner_id: 2, in_zone: true)
      ]
    end

    before { get '/api/pets' }

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all pets' do
      expect(json.size).to eq(2)
      expect(json[0]['pet_type']).to eq('Cat')
      expect(json[1]['pet_type']).to eq('Dog')
    end
  end

  describe 'POST /pets' do
    let(:valid_cat_params) do
      {
        pet: {
          pet_type: 'Cat',
          tracker_type: 'big',
          owner_id: 1,
          in_zone: false,
          lost_tracker: false
        }
      }
    end

    let(:invalid_params) do
      {
        pet: {
          pet_type: 'Fish', # Invalid type
          tracker_type: 'xl',
          owner_id: 'abc'
        }
      }
    end

    context 'with valid parameters' do
      before { post '/api/pets', params: valid_cat_params }

      it 'creates a new pet' do
        expect(response).to have_http_status(:created)
        expect(json['pet_type']).to eq('Cat')
      end
    end

    context 'with invalid parameters' do
      before { post '/api/pets', params: invalid_params }

      it 'returns validation errors' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['pet_type']).to include('is not included in the list')
        expect(json['tracker_type']).to be_present
      end
    end
  end

  describe 'GET /pets/outside_zone' do
    let!(:cat_outside) { Pet.create!(pet_type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: false, lost_tracker: true) }
    let!(:dog_outside) { Pet.create!(pet_type: 'Dog', tracker_type: 'big', owner_id: 2, in_zone: false) }
    let!(:cat_inside) { Pet.create!(pet_type: 'Cat', tracker_type: 'big', owner_id: 3, in_zone: true, lost_tracker: false) }

    before { get '/api/pets/outside_zone' }

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a count of pets outside the zone grouped by pet_type and tracker_type' do
      expect(json).to eq({
        'Cat' => { 'small' => 1 },
        'Dog' => { 'big' => 1 }
      })
    end
  end

  def json
    JSON.parse(response.body)
  end
end
