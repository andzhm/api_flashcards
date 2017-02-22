class Block < ApplicationRecord
  has_many :cards, dependent: :destroy
  belongs_to :user

  validates :title
end
