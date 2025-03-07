require 'rails_helper'

RSpec.describe 'Pets API', type: :request do
  let!(:pets) do
    [
      Pet.create!(pet_type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: false, lost_tracker: false),
      Pet.create!(pet_type: 'Dog', tracker_type: 'big', owner_id: 2, in_zone: true)
    ]
  end

  describe 'GET /api/pets' do
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

  def json
    JSON.parse(response.body)
  end
end
