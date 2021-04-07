# frozen_string_literal: true

class MembersController < ApplicationController
  include CurrencySupport

  layout 'fluid'

  def show
    render locals: { member: Member.find(params[:id]) }
  end

  def index
    render locals: { members: paginate(Member.order('created_at desc')) }
  end
end
