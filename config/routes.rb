Rails.application.routes.draw do
  root to: redirect('/api-docs')
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "users/registrations" }
  namespace :api do
    namespace :v1 do
      get 'current_user', to: 'users#current'
      resources :movies, only: [:index, :show, :create, :update, :destroy]
    end
  end
end