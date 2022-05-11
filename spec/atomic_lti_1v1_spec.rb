require 'rails_helper'


describe AtomicLti1v1 do 
  it "has version" do
    expect(AtomicLti1v1::VERSION.present?).to eq true
  end

describe AtomicLti1v1::Lti1v1Middleware do

  # Mock env to pass in middleware
  let(:env) do 
    Rack::MockRequest::env_for(
      "http://localhost/blog_posts", 
      :method => "POST", 
      :params => {
        oauth_consumer_key: "test_oauth_consumer_key", 
      }
    )

  end

  # dummy app to validate success
  let(:app) { ->(env) { [200, {}, "success"] } }
 
  subject { AtomicLti1v1::Lti1v1Middleware.new(app) }
  
  it "TODO" do
    status, _headers, _response = subject.call(env)
    expect(status).to eq(200)
  end
  
  before do
  end


end

end