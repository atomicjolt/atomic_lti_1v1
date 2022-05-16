require 'rails_helper'

describe AtomicLti1v1 do
  it 'has version' do
    expect(AtomicLti1v1::VERSION.present?).to eq true
  end

  describe AtomicLti1v1::Lti1v1Middleware do
    # Mock env to pass in middleware
    let(:env) do
      Rack::MockRequest.env_for(
        'https://discussions.atomicjolt.xyz/lti_launches/ZmfByCHPHFBco4EuwPMNYMw5',
        method: 'POST',
        params: { 'oauth_consumer_key' => 'atomicjolt-discussions', 'oauth_signature_method' => 'HMAC-SHA1',
                  'oauth_timestamp' => '1652710078', 'oauth_nonce' => 'AeGs7LJxArJ14DOdYiS55QHBR0YCeBZZIIxYu9JY', 'oauth_version' => '1.0', 'context_id' => 'eb247f6e77ee8af7964683c28297f865bcd0d6cb', 'context_label' => 'Discussions', 'context_title' => 'Discussions Local (Source)', 'custom_canvas_api_domain' => 'atomicjolt.instructure.com', 'custom_canvas_context_id_history' => '', 'custom_canvas_course_id' => '8032', 'custom_canvas_enrollment_state' => 'active', 'custom_canvas_resource_link_history' => '$ResourceLink.id.history', 'custom_canvas_user_id' => '19179', 'custom_canvas_user_login_id' => 'nick.benoit@atomicjolt.com', 'custom_canvas_workflow_state' => 'available', 'ext_roles' => 'urn:lti:instrole:ims/lis/Administrator,urn:lti:instrole:ims/lis/Instructor,urn:lti:role:ims/lis/Instructor,urn:lti:sysrole:ims/lis/User', 'launch_presentation_document_target' => 'iframe', 'launch_presentation_height' => '400', 'launch_presentation_locale' => 'en', 'launch_presentation_return_url' => 'https://atomicjolt.instructure.com/courses/8032', 'launch_presentation_width' => '800', 'lis_person_contact_email_primary' => 'nick.benoit@atomicjolt.com', 'lis_person_name_family' => 'Benoit', 'lis_person_name_full' => 'Nick Benoit', 'lis_person_name_given' => 'Nick', 'lis_person_sourcedid' => 'nick_aj', 'lti_message_type' => 'basic-lti-launch-request', 'lti_version' => 'LTI-1p0', 'oauth_callback' => 'about:blank', 'resource_link_id' => 'eb247f6e77ee8af7964683c28297f865bcd0d6cb', 'resource_link_title' => 'Atomic Discussions', 'roles' => 'Instructor,urn:lti:instrole:ims/lis/Administrator', 'tool_consumer_info_product_family_code' => 'canvas', 'tool_consumer_info_version' => 'cloud', 'tool_consumer_instance_contact_email' => 'notifications@instructure.com', 'tool_consumer_instance_guid' => '4MRcxnx6vQbFXxhLb8005m5WXFM2Z2i8lQwhJ1QT:canvas-lms', 'tool_consumer_instance_name' => 'Atomic Jolt', 'user_id' => 'e7c86da881d47b3f42eeab45a65d9f52d7348949', 'user_image' => 'https://canvas.instructure.com/images/messages/avatar-50.png', 'oauth_signature' => 'uyQtVhfp1BsEDwZNnqJZazrayuk=' }
      )
    end

    # dummy app to validate success
    let(:app) { ->(_env) { [200, {}, 'success'] } }

    subject do
      AtomicLti1v1.secret_provider = proc do
        '1f86a4385a871f55d12d68f552e28336bbda9a819df82a2b24319f78adc2932d42be4afc80769ab0cc4206ba4d8145e4c8ff88f051385b5822ef6c97e15e9e36'
      end

      AtomicLti1v1.skip_timestamp_validation = true
      AtomicLti1v1::Lti1v1Middleware.new(app)
    end

    describe 'Valid request' do
      it 'Sets atomic.validated.oauth_consumer_key' do
        status, _headers, _response = subject.call(env)
        expect(status).to eq(200)
        expect(env['atomic.validated.oauth_consumer_key']).to eq('atomicjolt-discussions')
      end

      # TODO
      # it "Should not be valid if we are validating timestamp" do
      # status, _headers, _response = subject.call(env)
      # expect(status).to eq(200)
      # epect(env['atomic.validated.oauth_consumer_key']).to eq("atomicjolt-discussions")
      # end
    end

    # describe "Invalid request" do
    #   it "TODO" do
    #     status, _headers, _response = subject.call(env)
    #     expect(status).to eq(200)
    #   end
    # end

    # describe "Non Lti 1.1 request" do
    #   it "TODO" do
    #     status, _headers, _response = subject.call(env)
    #     expect(status).to eq(200)
    #   end
    # end

    before do
    end
  end
end
