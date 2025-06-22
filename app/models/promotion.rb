class Promotion < ApplicationRecord
  PROMOTION_TYPES = %w[fixed bundle bulk percentage].freeze

  has_many :products, inverse_of: :promotion, dependent: :destroy
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  validates :promotion_type, inclusion: { in: PROMOTION_TYPES, allow_blank: false }
end
