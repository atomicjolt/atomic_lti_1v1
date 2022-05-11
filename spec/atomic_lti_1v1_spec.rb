require 'rails_helper'


describe AtomicLti1v1 do 

  # it "has version" do
  # end

describe AtomicLti1v1::Lti1v1Middleware do
  before do
    # @user = FactoryBot.create(:user)
  end

  it "test" do
    # token = AuthToken.issue_token({ user_id: @user.id })
    # decoded = AuthToken.valid?(token)
    # decoded_token = decoded[0]
    # expect(decoded_token["user_id"]).to eq @user.id
    expect(false).to eq true
  end
end

end


# class AtomicLti1v1Test < ActiveSupport::TestCase
#   test 'it has a version number' do
#     assert AtomicLti1v1::VERSION
#   end


#   test 'test' do 
#     let(:env) { Rack::MockRequest.env_for }

#     # dummy app to validate success
#     let(:app) { ->(env) { [200, {}, "success"] } }
#     subject { 
#       byebug
#       #.new(app) 
#     }


#   end


# end
