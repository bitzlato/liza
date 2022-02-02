# frozen_string_literal: true

class MemberTransfer < PeatioRecord
  include OperationsReferences

  belongs_to :member
  belongs_to :currency

  delegate :uid, to: :member, prefix: true
end
