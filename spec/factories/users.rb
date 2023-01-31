FactoryBot.define do
  factory :user do
    email                           {Faker::Internet.free_email}
    password                        {'abc1234'}
    password_confirmation           {'abc1234'}
    nickname                        {Faker::Name.initials(number: 2)}
    name_kana                      {'カナ'}
    area                           {'北海道'}
  end
end

