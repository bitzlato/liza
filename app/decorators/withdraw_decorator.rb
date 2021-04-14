class WithdrawDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member created_at updated_at currency aasm_state sum amount fee type txid tid rid note beneficiary transfer_type error note]
  end

  def sum
    h.format_money object.sum, object.currency
  end

  def amount
    h.format_money object.amount, object.currency
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
