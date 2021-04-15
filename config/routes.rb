# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  scope Settings.root_prefix do
    root to: 'dashboard#index'
    resources :reports do
      collection do
        get :wd # withdraw and deposits
      end
    end
    resources :withdraws
    resources :deposits
    resources :transactions
    resources :accounts
    resources :trades
    resources :orders
    resources :members
    namespace :operations do
      resources :liabilities
      resources :accounts
      resources :assets
      resources :expenses
      resources :revenues
    end
  end
end
