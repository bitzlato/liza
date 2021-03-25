module ApplicationHelper
  def app_title
    I18n.t 'titles.application'
  end

  def format_money(amount, currency_id)
    content_tag :code do
      # TODO Взять число после запятой с валюты
      "%0.8f" % amount
    end
  end
end
