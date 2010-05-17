# seems that it's better to create the associations from :user

Factory.define :user do |f|
  f.sequence(:name)  { |n| "user #{n}" }
  f.sequence(:username)  { |n| "user#{n}" }
  f.sequence(:email) { |n| "user#{n}@example.com" }
  f.password "password"
end

Factory.define :group do |f|
  f.association :creator, :factory => :user
  f.sequence(:name)  { |n| "group #{n}" }
  f.sequence(:description) { |n| "description of group #{n}" }
end
