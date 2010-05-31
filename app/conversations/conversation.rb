class Conversation < ActiveRecord::Base
  include Conversational::Conversation
  Conversation.converse do |with, notice|
    Mail.deliver do
      to with
      from "someone@example.com"
      subject notice
      body notice
    end
  end
end
