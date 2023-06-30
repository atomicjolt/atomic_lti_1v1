# AtomicLti1v1
A middleware to validate LTI 1.1 requests. When a request is determined to be an lti launch, the middleware will validate the request. Upon a successful validation the `oauth_consumer_key` will be added to the rack environment here: `atomic.validated.oauth_consumer_key`.

## Usage

In another middleware, the validated oauth_consumer_key can be accessed like this:
```

def call(env)
  env['atomic.validated.oauth_consumer_key'] # Validated oauth consumer key

```

In the rails app, the validated oauth_consumer_key can be accessed like this: 

```
request.env["atomic.validated.oauth_consumer_key"]
```


## Installation

<!-- * Add to gemfile TODO should we pull in tag, or what?
  
  `gem 'atomic_lti_1v1', git: '/Users/nickbenoit/Projects/atomic_lti_1v1'` -->

### Install migrations

```bash
bin/rails atomic_lti1v1:install:migrations
```
This will copy only previously uncopied migrations to your project.


### Add initializer
Create file `config/initializers/atomic_lti_1v1.rb`
Provide `secret_provider`

  ```ruby
  # Lookup an lti_secret from an oauth_consumer_key
  AtomicLti1v1.secret_provider = Proc.new do |oauth_consumer_key| 
    # If using most Atomic Jolt Apps, probably something like this
    ApplicationInstance.find_by(lti_key: oauth_consumer_key)&.lti_secret 
  end
  # List of path prefixes to handle. Default is the following:
  AtomicLti1v1.path_prefixes = ["/lti_launches"] 
  ```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
