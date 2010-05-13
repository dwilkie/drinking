# Taken from conversation gem
Given /^#{capture_model} is (.+)$/ do |conversation, state|
  conversation = model!(conversation)
  conversation.state = state
  conversation.save!
end
