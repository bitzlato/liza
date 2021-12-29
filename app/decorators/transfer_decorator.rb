# frozen_string_literal: true

class TransferDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id key description category liabilities revenues created_at updated_at]
  end

  def liabilities
    h.link_to "Liabilities(#{object.liability_amount})", h.operations_liabilities_path(q: { reference_id_eq: object.id, reference_type_eq: object.class.name })
  end

  def revenues
    h.link_to "Revenues(#{object.revenues_amount})", h.operations_revenues_path(q: { reference_id_eq: object.id, reference_type_eq: object.class.name })
  end
end
