class Api::PetsController < ApplicationController
  def index
    @pets = Pet.all
    render json: @pets
  end

  def show
    @pet = Pet.find(params[:id])
    render json: @pet
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Pet not found" }, status: :not_found
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
    result = {}

    count.each do |(pet_type, tracker_type), count_value|
      result[pet_type] ||= {}
      result[pet_type][tracker_type] = count_value
    end

    render json: result
  end

  private

  def pet_params
    params.require(:pet).permit(:pet_type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end
end
