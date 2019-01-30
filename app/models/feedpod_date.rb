class FeedpodDate < ApplicationRecord
  has_many :feedpodrecords, dependent: :destroy
  validates :date, presence: true
end
