class BaseGenerator
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def perform
    raise 'implement'
  end
end
