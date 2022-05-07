Rails.application.routes.draw do
  mount AtomicLti1v1::Engine => "/atomic_lti_1v1"
end
