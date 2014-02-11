
FactoryGirl.define do
  factory :member, :class => Refinery::Members::Member do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

