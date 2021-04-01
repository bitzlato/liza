# frozen_string_literal: true

json.extract! withdraw, :id, :created_at, :updated_at
json.url withdraw_url(withdraw, format: :json)
