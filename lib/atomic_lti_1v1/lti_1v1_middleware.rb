
module AtomicLti1v1
class Lti1v1Middleware
    def initialize app
      @app = app
    end
  
    def call env
      # do something...
       @app.call(env)
    end
end
end