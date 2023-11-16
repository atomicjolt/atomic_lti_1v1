require 'rails_helper'

module AtomicLti1v1
  RSpec.describe AtomicLti1v1::Lti1v1Middleware do
    # dummy app to validate success
    let(:app) { ->(env) { [200, {}, [env]] } }
    let(:middleware) { described_class.new(app) }

    describe '#call' do
      context 'when the request is not for a path prefix' do
        let(:oauth_consumer_key) { '123' }
        let(:lti_secret) { 'secret' }
        let(:lti_options) {
          lti_params(oauth_consumer_key, lti_secret, {
            "launch_url" => "https://test.atomicjolt.xyz/some_other_path",
          })
        }
        let(:request_env) {
          Rack::MockRequest.env_for(
            "https://test.atomicjolt.xyz/some_other_path",
            { method: "POST", params: lti_options },
          )
        }

        it 'does not set the validated oauth_consumer_key in the env' do
          expect { middleware.call(request_env) }.not_to change { request_env['atomic.validated.oauth_consumer_key'] }
        end

        it 'does not set the state_validation flag' do
          expect { middleware.call(request_env) }.not_to change { request_env['atomic.validated.state_validation'] }
        end
      end

      context 'when the request is an LTI 1.1 request' do
        let(:oauth_consumer_key) { '123' }
        let(:lti_secret) { 'secret' }
        let(:lti_options) {
          lti_params(oauth_consumer_key, lti_secret, {
            "launch_url" => "https://test.atomicjolt.xyz/lti_launches",
          })
        }
        let(:request_env) {
          Rack::MockRequest.env_for(
            "https://test.atomicjolt.xyz/lti_launches",
            { method: "POST", params: lti_options },
          )
        }

        before do
          allow(AtomicLti1v1).to receive(:secret_provider).and_return(->(_oauth_consumer_key) { lti_secret })
        end

        context 'when the LTI request is valid' do
          it 'sets the validated oauth_consumer_key in the env' do
            expect { middleware.call(request_env) }.to change { request_env['atomic.validated.oauth_consumer_key'] }.from(nil).to(oauth_consumer_key)
          end

          it 'sets the state_validation flag to true' do
            expect { middleware.call(request_env) }.to change { request_env['atomic.validated.state_validation'] }.from(nil).to({ state_verified: true })
          end
        end

        context 'when the LTI request has invalid parameters' do
          it 'raises an LtiValidationFailed error' do
            lti_options['context_title'] = 'invalid'
            invalid_request_env = Rack::MockRequest.env_for(
              "https://test.atomicjolt.xyz/lti_launches",
              { method: "POST", params: lti_options },
            )

            expect { middleware.call(invalid_request_env) }.to raise_error(AtomicLti1v1::LtiValidationFailed, "Validation failed for oauth_consumer_key: #{oauth_consumer_key}")
          end
        end

        context 'when the LTI request is too old' do
          it 'raises an LtiValidationFailed error' do
            old_launch_params = lti_params(oauth_consumer_key, lti_secret, {
              "launch_url" => "https://test.atomicjolt.xyz/lti_launches",
              "timestamp" => (Time.now - 10.minutes).utc.to_i.to_s,
            })

            invalid_request_env = Rack::MockRequest.env_for(
              "https://test.atomicjolt.xyz/lti_launches",
              { method: "POST", params: old_launch_params },
            )

            expect { middleware.call(invalid_request_env) }.to raise_error(AtomicLti1v1::LtiValidationFailed, "Validation failed for oauth_consumer_key: #{oauth_consumer_key}")
          end
        end

        context 'when the nonce is invalid' do
          it 'raises an LtiValidationFailed error' do
            launch_params = lti_params(oauth_consumer_key, lti_secret, {
              "launch_url" => "https://test.atomicjolt.xyz/lti_launches",
            })

            invalid_request_env = Rack::MockRequest.env_for(
              "https://test.atomicjolt.xyz/lti_launches",
              { method: "POST", params: launch_params },
            )
            AtomicLti1v1::Nonce.create!(nonce: launch_params['oauth_nonce'])

            expect { middleware.call(invalid_request_env) }.to raise_error(AtomicLti1v1::LtiValidationFailed, "Validation failed for oauth_consumer_key: #{oauth_consumer_key}")
          end
        end

        context 'when no LTI secret is found for the oauth_consumer_key' do
          let(:lti_secret) { nil }

          it 'logs a warning' do
            expect(Rails.logger).to receive(:warn).with("No lti secret found for oauth_consumer_key: #{oauth_consumer_key}")
            middleware.call(request_env)
          end
        end

        context 'when an error occurs while looking up the LTI secret' do
          let(:error_message) { 'Something went wrong' }

          before do
            allow(AtomicLti1v1).to receive(:secret_provider).and_return(->(_oauth_consumer_key) { raise StandardError, error_message })
          end

          it 'logs an error' do
            expect(Rails.logger).to receive(:error).with("Error looking up lti secret, #{error_message}")
            middleware.call(request_env)
          end
        end
      end

      context 'when the request is not an LTI 1.1 request' do
        let(:request_env) {
          Rack::MockRequest.env_for(
            "https://test.atomicjolt.xyz/lti_launches",
            { method: "POST", params: { "iss" => "https://canvas.instructure.com" } },
          )
        }

        it 'does not set the validated oauth_consumer_key in the env' do
          expect { middleware.call(request_env) }.not_to change { request_env['atomic.validated.oauth_consumer_key'] }
        end

        it 'does not set the state_validation flag' do
          expect { middleware.call(request_env) }.not_to change { request_env['atomic.validated.state_validation'] }
        end
      end
    end
  end
end
