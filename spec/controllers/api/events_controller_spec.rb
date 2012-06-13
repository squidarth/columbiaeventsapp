require 'spec_helper'

describe Api::EventsController do

  describe "GET 'upcoming'" do
    it "should be successful" do
      get 'upcoming'
      response.should be_success
    end
  end

  describe "GET 'recent'" do
    it "should be successful" do
      get 'recent'
      response.should be_success
    end
  end

end
