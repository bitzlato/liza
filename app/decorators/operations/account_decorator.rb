class Operations::AccountDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[code type kind currency_type scope description]
  end
end
