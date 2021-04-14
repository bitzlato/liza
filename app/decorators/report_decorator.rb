class ReportDecorator < ApplicationDecorator
  delegate_all

  def form
    h.render 'reports/present_form', form: object.form_object
  end

  def results
    h.link_to h.report_path(object) do
      I18n.t '.results'
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
