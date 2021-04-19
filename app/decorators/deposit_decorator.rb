class DepositDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member created_at updated_at currency aasm_state amount fee type txid txout tid transfer_type address data]
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
