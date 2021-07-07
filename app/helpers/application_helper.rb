# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module ApplicationHelper
  def title_with_count(title, count)
    return title if count.to_i.zero?

    "#{title} (#{count})"
  end

  def present_time(time, default)
    return default if time.blank?

    l time, format: :short
  end

  def app_title
    I18n.t 'titles.application'
  end

  def active_class(css_classes, flag)
    flag ? "#{css_classes} active" : css_classes
  end

  def column_tip(buffer)
    content_tag :small, buffer, class: 'text-small text-monospace'
  end

  def back_link(url = nil)
    link_to ('&larr; ' + t('.back')).html_safe, url || root_url
  end

  def middot
    content_tag :div, '&middot;'.html_safe, class: 'text-muted'
  end

  def grouped_operations(operations)
    operations.group(:currency_id).pluck(:currency_id, 'sum(credit), sum(debit)').each_with_object({}) do |i, a|
      a[i.first] = { credit: i[1], debit: -i[2], balance: i[1] - i[2] }
    end
  end

  def sort_column(column, title)
    sort_link q, column, title
  end

  def format_liability_account(account)
    link_to account do
      account.description + ' [' + account.scope + ']'
    end
  end

  def download_link(url = nil, size = nil)
    title = size.present? ? t('helpers.download_with_size', ext: 'xlsx', size: size) : t('helpers.download_without_size', ext: 'xlsx')
    link_to url || url_for(format: :xlsx), class: 'text-nowrap' do
      content_tag(:span, '⬇', class: 'mr-1') + title
    end
  end
end
