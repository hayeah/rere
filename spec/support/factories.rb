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

Factory.define :thought do |f|
  f.association :user, :factory => :user
  f.sequence(:content)  { |n| "content #{n}" }
end

Factory.define :shared_thought do |f|
  f.association :subject, :factory => :user
  f.association :thought, :factory => :thought
end

