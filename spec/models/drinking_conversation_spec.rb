require 'spec_helper'

describe DrinkingConversation do
  let(:valid_attributes) { {:topic => "drinking", :with => "someone" } }

  describe "#move_along!" do
    let(:conversation) { DrinkingConversation.create!(valid_attributes) }
    context "conversation is new" do
      it "should ask the user if they would like a drink" do
        conversation.should_receive(:say).with("Would you like a drink?")
        conversation.move_along!
      end
      it "should update the conversation state to offered_drink" do
        conversation.move_along!
        conversation.state.should == "offered_drink"
      end
    end
    context "already offered the user a drink" do
      before {
        conversation.offer_drink
      }
      context "they say yes" do
        it "should suggest beer" do
          conversation.should_receive(:say).with("I suggest Beer")
          conversation.move_along!("yes")
        end
      end
      context "they say no" do
        it "should say You've changed" do
          conversation.should_receive(:say).with("You've changed")
          conversation.move_along!("no")
        end
      end
      context "they say something else..." do
        it "should suggest scotch" do
          conversation.should_receive(:say).with("I suggest Scotch")
          conversation.move_along!("piss off")
        end
      end
      it "should update the conversation state to finished" do
        conversation.move_along!
        conversation.state.should == "finished"
      end
    end
    context "there are finishing keywords defined" do
      before {
        Conversation.finishing_keywords = ["stop", "halt"]
      }
      context "a finishing keyword was received" do
        it "should change the state to finished" do
          conversation.move_along!("stop")
          conversation.should be_finished
        end
      end
      context "a finishing keyword was not received" do
        it "should not change the state to finished" do
          conversation.move_along!("now")
          conversation.should_not be_finished
        end
      end
    end
    context "there are no finishing keywords" do
      before {
        Conversation.finishing_keywords = nil
      }
      it "should not change the state to finished" do
        conversation.move_along!("stop")
        conversation.should_not be_finished
      end
    end
  end
end

