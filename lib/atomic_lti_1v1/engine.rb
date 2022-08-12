module AtomicLti1v1
  class Engine < ::Rails::Engine
    isolate_namespace AtomicLti1v1
    initializer "atomic_lti.middleware" do |app|
      app.config.app_middleware.insert_before Warden::Manager, AtomicTenant::CurrentApplicationInstanceMiddleware
      app.config.app_middleware.insert_before AtomicTenant::CurrentApplicationInstanceMiddleware, AtomicLti1v1::Lti1v1Middleware
    end

    # middleware.use  AtomicLti1v1::Lti1v1Middleware
  end
end
