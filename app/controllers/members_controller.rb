# frozen_string_literal: true

class MembersController < ResourcesController
  layout 'fluid'

  def show
    render locals: { member: Member.find(params[:id]) }
  end
end
