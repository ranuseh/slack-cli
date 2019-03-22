require "simplecov"
SimpleCov.start

require_relative "test_helper"
require_relative "../lib/workspace.rb"

describe "Workspace class" do
  before do
    VCR.use_cassette("workspace_creation") do
      @workspace = Slack::Workspace.new
    end
  end

  it "creates an instance of Workspace" do
    expect(@workspace).must_be_kind_of Slack::Workspace
  end

  it "has an array of Users" do
    expect(@workspace.users).must_be_kind_of Array
    expect(@workspace.users[0]).must_be_kind_of Slack::User
  end

  it "has an array of Channels" do
    expect(@workspace.channels).must_be_kind_of Array
    expect(@workspace.channels[0]).must_be_kind_of Slack::Channel
  end

  describe "select_channel" do
    it "can select a Channel based on id" do
      @workspace.select_channel("CH0EE9NJC")
      expect(@workspace.selected).must_be_kind_of Slack::Channel
    end

    it "can select a Channel based on name" do
      @workspace.select_channel("general")
      expect(@workspace.selected).must_be_kind_of Slack::Channel
      expect(@workspace.selected.name).must_equal "general"
    end

    it "returns nil if given invalid identifier" do
      @workspace.select_channel("INVALID_IDENTIFIER")
      expect(@workspace.selected).must_equal nil
    end
  end

  describe "select_user" do
    it "can select a User based on id" do
      @workspace.select_user("USLACKBOT")
      expect(@workspace.selected).must_be_kind_of Slack::User
      expect(@workspace.selected.name).must_equal "slackbot"
    end

    it "can select a User based on username" do
      @workspace.select_user("v.jansen.martin")
      expect(@workspace.selected).must_be_kind_of Slack::User
      expect(@workspace.selected.name).must_equal "v.jansen.martin"
    end

    it "returns nil if given invalid identifie" do
      @workspace.select_user("INVALID_IDENTIFIER")
      expect(@workspace.selected).must_equal nil
    end

    describe "show_details" do
      it "does a thing" do
        @workspace.select_user("v.jansen.martin")
        expect(@workspace.show_details).must_be_kind_of Terminal::Table
      end
      # tests for show_details here
    end

    describe "send_message" do
      it "sends a message to a user" do
        VCR.use_cassette("send_message_to_user") do
          # @workspace.users << Slack::User.new(
          #   name: "Bogus",
          #   real_name: "Bogus",
          #   slack_id: "Bogus",
          #   status_text: "Bogus",
          #   status_emoji: "Bogus",
          # )
          @workspace.selected = @workspace.users[2]
          response = @workspace.send_message("This goes to a user!")
          expect(response).must_equal true
        end
      end

      it

      it "will raise an error when given an invalid user" do
      end
    end
  end
end
