FactoryGirl.define do
  factory :card do
    original_text 'тест'
    translated_text 'test'
    user
    block
  end
end
