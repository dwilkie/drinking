When /^"([^\"]*)" replies with "([^\"]*)"$/ do |with, summary|
  conversation = Conversation.with(with).last
  conversation.details.move_along(summary) if conversation
end

When /^I move #{capture_model} along(?: with: "([^\"]*)")?$/ do |name, message|
  model!(name).move_along(message)
end

Then /^"([^\"]*)" should (not )?be notified with "([^\"]*)" via (\w+)/ do |to, notify, summary, via|
  if via == "email"
    unless notify =~ /not/
      Then "\"#{to}\" should receive an email with subject \"#{summary}\""
    else
      Then "\"#{to}\" should receive no emails with subject \"#{summary}\""
    end
  end
end

Then /^#{capture_model} should have the state: "([^\"]*)"$/ do |name, state|
  model!(name).state.should == state
end

