# frozen_string_literal: true

json.array! @withdraws, partial: 'withdraws/withdraw', as: :withdraw
