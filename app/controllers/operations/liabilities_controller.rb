class Operations::LiabilitiesController < ApplicationController
  layout 'fluid'

  def index
    render locals: { liabilities: liabilities }
  end

  private

  def liabilities
    Operations::Liability.includes(:member).order('created_at desc')
  end
end
