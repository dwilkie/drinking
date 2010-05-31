class DrinkingConversation < Conversation
  state_machine :state do
    event :offer_drink do
      transition nil => :offered_drink
    end
    
    event :finish do
      transition :offered_drink => :finished
    end
  end

  def move_along(message=nil)
    case state

    when nil
      say "Would you like a drink?"
      offer_drink

    when "offered_drink"
      message ||= ""
      case message.downcase

      when "yes"
        say "I suggest Beer"

      when "no"
        say "You've changed"

      else
        say "I suggest Scotch"
      end
      finish
    end
  end
end

