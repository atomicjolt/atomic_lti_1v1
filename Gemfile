source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in atomic_lti_1v1.gemspec.
gemspec

gem 'sqlite3'

gem 'sprockets-rails'

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'

  gem 'ims-lti', '~> 2.1.5' # IMS LTI tool consumers and providers
end
