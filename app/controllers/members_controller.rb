# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class MembersController < ResourcesController
  layout 'fluid'

  def show
    render locals: { member: Member.find(params[:id]) }
  end

  private

  def index_form
    'members_form'
  end
end
