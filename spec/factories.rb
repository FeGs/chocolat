FactoryGirl.define do
  factory :api_key do
    scope 'read_key'
    project
  end

  factory :project do
  end
end