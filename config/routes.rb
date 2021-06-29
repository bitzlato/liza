# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  mount Sidekiq::Web => Settings.root_prefix + '/sidekiq'
  scope Settings.root_prefix do
    root to: 'dashboard#index'
    resources :reports
    resources :withdraws
    resources :deposits
    resources :transactions
    resources :accounts
    resources :trades
    resources :orders
    resources :members
    resources :adjustments
    namespace :operations do
      resources :liabilities
      resources :accounts
      resources :assets
      resources :expenses
      resources :revenues
    end
  end
end
