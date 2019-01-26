class Day < ApplicationRecord
  # belongs_to :user
  has_many :records, dependent: :destroy
  validates :date, presence: true
end
