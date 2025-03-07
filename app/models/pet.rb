class Pet < ApplicationRecord
  validates :pet_type, presence: true, inclusion: { in: %w[Cat Dog] }
  validates :tracker_type, presence: true
  validates :owner_id, presence: true, numericality: { only_integer: true }
  validates :in_zone, presence: true, inclusion: { in: [ true, false ] }

  validate :tracker_type_valid
  validate :lost_tracker_valid

  private

  def tracker_type_valid
    case pet_type
    when "Cat"
      errors.add(:tracker_type, "must be small or big for Cats") unless %w[small big].include?(tracker_type)
    when "Dog"
      errors.add(:tracker_type, "must be small, medium, or big for Dogs") unless %w[small medium big].include?(tracker_type)
    end
  end

  def lost_tracker_valid
    if pet_type == "Cat"
      errors.add(:lost_tracker, "must be present for Cats") if lost_tracker.nil?
    else
      errors.add(:lost_tracker, "must be blank for Dogs") if lost_tracker.present?
    end
  end
end
