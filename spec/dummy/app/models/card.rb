class Card < ApplicationRecord
  belongs_to :user
  belongs_to :block
  validates :user_id, presence: true
  before_validation :set_review_date_as_now, on: :create
  validate :texts_are_not_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }
  validates :block_id,
            presence: { message: 'Выберите колоду из выпадающего списка.' }

  scope :pending, -> { where('review_date <= ?', Time.now).order('RANDOM()') }
  scope :repeating, -> { where('quality < ?', 4).order('RANDOM()') }

  def check_translation(user_translation)

  end

  protected

  def set_review_date_as_now
    self.review_date = Time.now
  end

  def texts_are_not_equal
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end

