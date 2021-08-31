# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  mount Sidekiq::Web => '/sidekiq'
  root to: 'dashboard#index'
  resources :reports
  resources :withdraws
  resources :deposits
  resources :transactions
  resources :accounts
  resources :trades
  resources :markets
  resources :orders
  resources :members
  resources :adjustments
  resources :service_withdraws, only: %i[index show]
  resources :service_invoices, only: %i[index show]
  resources :service_transactions, only: %i[index show]
  resources :wallets, only: %i[index show]
  resources :payment_addresses, only: %i[index show]
  resources :currencies, only: %i[index show]
  resources :blockchains, only: %i[index show]
  namespace :operations do
    resources :liabilities
    resources :accounts
    resources :assets
    resources :expenses
    resources :revenues
  end
end
