Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace 'api' do
    namespace 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :sleep_patterns
      resources :timings
      resources :loads
      resources :dailies
      resources :results
      # ログインユーザー取得のルーティング
      namespace :auth do
        resources :sessions, only: %i[index]
      end
    end
  end
end
