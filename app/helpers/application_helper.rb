# frozen_string_literal: true

module ApplicationHelper
  def app_title
    I18n.t 'titles.application'
  end

  def active_class(css_classes, flag)
    flag ? "#{css_classes} active" : css_classes
  end

  def column_tip(buffer)
    content_tag :small, buffer, class: 'text-small text-monospace text-nowrap'
  end

  def back_link(url = nil)
    link_to '&larr; back'.html_safe, url || root_url
  end
end
