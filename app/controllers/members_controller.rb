class MembersController < ApplicationController
  include CurrencySupport

  layout 'fluid'

  def show
    render locals: { member: Member.find(params[:id]) }
  end

  def index
    render locals: { members: Member.order('created_at desc') }
  end
end
