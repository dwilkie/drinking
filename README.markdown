# Drinking Conversation

This is an example Rails 3 application which shows you how to use [Conversation](http://github.com/dwilkie/conversation) to have stateful conversations.

This example is a virtual waiter application which offers a user a drink then responds differently depending on the users response.

Let's say you want to send a user a text message asking them if they would like a drink. Depending on their response you would reply differently. You can handle this situation by using Conversation. Here's an example:

<pre>
  class DrinkingConversation < Conversation
    state_machine :state do
      event :offer_drink do
        transition :new => :offered_drink
      end
      
      event :finish do
        transition :offered_drink => :finished
      end
    end

    def move_along!(message=nil)
      case state

      when "new"
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
      super(message)
    end
  end

  class IncomingTextMessage < ActiveRecord::Base
  end
  
  class IncomingTextMessagesController < ApplicationController
    def create
      IncomingTextMessage.create(params[:message_text], params[:number])
    end
  end
  
  class IncomingTextMessageObserver < ActiveRecord::Observer
    def after_create(message)
      topic = message.text.split(" ").first
      Conversation.find_or_create_with(message.number, topic).move_along!(message.text)
    end
  end
  
  class OutgoingTextMessage < ActiveRecord::Base
    def send
      # some code to send a text message
      sent = true
    end
  end
  
  # config/initializers/conversation.rb
  Conversation.converse do |with, message|
    OutgoingTextMessage.create!(:to => with, :message => message).send
  end
</pre>

Now let's play in the console:

<pre>
  conversation = Conversation.new(:with => "08614166112", :topic => "drinking")
  => #<Conversation topic: "drinking", with: "08614166112",:state => "new">
  conversation.details
  => #<DrinkingConversation topic: "drinking", with: "08614166112", :state => "new">
  conversation.details.move_along!
  OutgoingTextMessage.last
  => #<OutgoingTextMessage
       to: "08614166112",
       message: "Would you like a drink?",
       sent: "true"
     >
  # some time has passed...
  IncomingTextMessage.last
  => #<IncomingTextMessage
       message: "yes",
       number: "08614166112"
      >
  OutgoingTextMessage.last
  => #<OutgoingTextMessage
       to: "08614166112",
       message: "I suggest Beer",
       sent: "true"
     >
</pre>

The magic happens inside the `IncomingTextMessageObserver`. When calling `Conversation.find_or_create_with("08614166112", "yes")`, Conversation by default looks for any Conversations with "08614166112" that are not "finished" within the last 24 hours. If it finds one it will return the subclass of Conversation based off the topic. In this case it returns an instance of `DrinkingConversation`. `move_along!` is then called on `DrinkingConversation` which has the state: "offered_drink" and it calls `say` on the conversation with "I suggest Beer". `say` then does whatever you told it to in `config/initializers/conversation.rb`. In this case we told it to create a new `OutgoingTextMessage` to whoever we are having the conversation with and send the message.

Conversations don't have to be over text message as shown in this example, they could be over email, IM or whatever you want.

Head back to [Conversation](http://github.com/dwilkie/conversation) for more info on configuring it.

If you want to you can install this sample app and run the features and specs.

## Installation

<pre>
git clone git://github.com/dwilkie/drinking.git
cd drinking
bundle install
rake db:migrate
rake db:test:clone
</pre>

## Running the features using Cucumber

`cucumber features`

## Running the spec

`rspec -c ./spec/models/drinking_conversation_spec.rb`

Copyright (c) 2010 David Wilkie, released under the MIT license
