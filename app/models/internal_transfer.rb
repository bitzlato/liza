class InternalTransfer < ApplicationRecord
  belongs_to :currency
  belongs_to :sender, class_name: :Member, required: true
  belongs_to :receiver, class_name: :Member, required: true
  enum state: { completed: 1 }

  def direction(user)
    user == sender ? 'out' : 'in'
  end
end
