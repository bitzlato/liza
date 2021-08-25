# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module BlockchainSupport
  extend ActiveSupport::Concern

  included do
    helper_method :blockchain
  end

  private

  def blockchain
    blockchain_id = params.dig(:q, :blockchain_id_eq)
    Blockchain.find_by(id: blockchain_id) || raise(HumanizedError, "No such blockchain #{blockchain_id}") if blockchain_id.present?
  end
end
