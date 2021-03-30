Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  scope Settings.root_prefix do
    root to: 'dashboard#index'
    resources :reports
    resources :withdraws
    resources :accounts
    namespace :operations do
      resources :liabilities
    end
  end
end
