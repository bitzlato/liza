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
    link_to ('&larr; ' + t('.back')).html_safe, url || root_url
  end

  def middot
    content_tag :div, '&middot;'.html_safe, class: 'text-muted'
  end

  def grouped_operations(operations)
    operations.group(:currency_id).pluck(:currency_id, 'sum(credit), sum(debit)').each_with_object({}) { |i, a| a[i.first] = { credit: i[1], debit: -i[2], balance: i[1] - i[2] } }
  end

  def sort_column(column, title)
    next_order = :desc
    sort_link q, column, title
  end
end
