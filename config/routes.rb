Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :sleep_patterns
      resources :timings
      resources :dailies
    end
  end
end
