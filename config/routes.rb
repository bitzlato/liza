Rails.application.routes.draw do
  # default_url_options Settings.default_url_options.symbolize_keys

  scope '/liza' do
    root to: 'dashboard#index'
  end
end
