class Pet < ApplicationRecord
  validates :pet_type, presence: true, inclusion: { in: %w[Cat Dog] }
  validates :tracker_type, presence: true
  validates :owner_id, presence: true, numericality: { only_integer: true }
  validates :in_zone, inclusion: { in: [ true, false ] }

  validate :validate_tracker_type
  validate :validate_lost_tracker

  private

  def validate_tracker_type
    case pet_type
    when "Cat"
      errors.add(:tracker_type, "must be small or big for Cats") unless %w[small big].include?(tracker_type)
    when "Dog"
      errors.add(:tracker_type, "must be small, medium, or big for Dogs") unless %w[small medium big].include?(tracker_type)
    else
      errors.add(:tracker_type, "is invalid") if tracker_type.present?
    end
  end

  def validate_lost_tracker
    if pet_type == "Cat"
      errors.add(:lost_tracker, "must be present for Cats") if lost_tracker.nil?
    else
      errors.add(:lost_tracker, "must be blank for Dogs") if lost_tracker.present?
    end
  end
end
