# frozen_string_literal: true

module Operations
  class RevenuesController < ApplicationController
    include CurrencySupport

    layout 'fluid'

    def index
      render locals: {
        revenues: paginate(revenues),
        member: member,
        totals: {
          debit: revenues.sum(:debit),
          credit: revenues.sum(:credit),
        }
      }
    end

    def show
      render locals: { record: Operations::Revenue.find(params[:id]) }
    end

    private

    def member
      Member.find params[:member_id] if params[:member_id].present?
    end

    def revenues
      scope = Operations::Revenue
      scope = scope.where member_id: member.id if member.present?
      scope = scope.where currency_id: currency.id if currency.present?
      scope.order('created_at desc')
    end
  end
end
