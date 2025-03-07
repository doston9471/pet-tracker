class Api::PetsController < ApplicationController
  def index
    @pets = Pet.all
    render json: @pets
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.save
      render json: @pet, status: :created
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  def outside_zone
    count = Pet.where(in_zone: false).group(:pet_type, :tracker_type).count
    formatted_count = count.each_with_object({}) do |((pet_type, tracker_type), value), hash|
      hash[pet_type] ||= {}
      hash[pet_type][tracker_type] = value
    end
    render json: formatted_count
  end

  private

  def pet_params
    params.require(:pet).permit(:pet_type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end
end
