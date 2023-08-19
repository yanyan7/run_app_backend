Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace 'api' do
    namespace 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :sleep_patterns
      resources :timings
      resources :dailies
      resources :results
    end
  end
end
