class User < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :blocks, dependent: :destroy
end
