# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  TEXT_RIGHT = %i[debit credit amount locked total price volume origin_volume origin_locked funds_received maker_fee
                  taker_fee].freeze

  def self.table_th_class(column)
    return 'text-right' if TEXT_RIGHT.include? column
  end

  def self.table_td_class(column)
    table_th_class column
  end

  def self.attributes
    table_columns
  end

  def currency
    h.format_currency object.currency
  end

  def member
    h.render 'member_brief', member: object.member
  end

  def created_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.created_at, format: :short
    end
  end
end
