# Drinking Conversation

This is an example Rails 3 application which shows you how to use [Conversational](http://github.com/dwilkie/conversational) to have stateful conversations.

This example is a virtual waiter application which offers a user a drink then responds differently depending on their response.

## Installation

    git clone git://github.com/dwilkie/drinking.git
    cd drinking
    bundle install
    rails g conversational:migration
    rake db:migrate
    rake db:test:clone

## Running the features using Cucumber

`cucumber features`

## Running the spec

`rspec -c ./spec/models/drinking_conversation_spec.rb`

Copyright (c) 2010 David Wilkie, released under the MIT license
