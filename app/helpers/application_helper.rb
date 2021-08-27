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

  def find_fee_currency(currency_id)
    Currency.find(currency_id).blockchain.fee_currency
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

  def hide_column(column)
    link_to '[×]', url_for(q: params.fetch(:q, {}).permit!, hide_columns: hided_columns + [column]), class: 'ml-2'
  end

  def unhide_column_url(column)
    url_for(q: params.fetch(:q, {}).permit!, hide_columns: hided_columns - [column])
  end

  def format_liability_account(account)
    link_to account do
      account.description + ' [' + account.scope + ']'
    end
  end

  def present_address_kind(kind)
    css_class = {
      'deposit' => 'badge badge-success',
      'unknown' => 'badge badge-secondary',
      'wallet' => 'badge badge-warning',
      'absence' => 'badge badge-secondary',
      nil => 'badge badge-warning'
    }
    content_tag :span, kind || :null, class: css_class[kind] || 'badge badge-danger'
  end

  def present_kind(kind)
    css_class = {
      'withdraw' => 'badge badge-primary',
      'gas_refuel' => 'badge badge-info',
      'refill' => 'badge badge-info',
      'deposit' => 'badge badge-success',
      'collection' => 'badge badge-success',
      'unknown' => 'badge badge-warning',
      'internal' => 'badge badge-secondary',
      'unauthorized_withdraw' => 'badge badge-warning',
      'none' => 'badge badge-secondary',
      nil => 'badge badge-warning'
    }
    content_tag :span, kind || :null, class: css_class[kind] || 'badge badge-danger'
  end

  # rubocop:disable Metrics/MethodLength
  def present_address(address)
    owner = PaymentAddress.find_by_address(address) || Wallet.find_by_address(address) || Withdraw.find_by_address(address)
    details = case owner
              when Wallet
                link_to wallet_path(owner) do
                  content_tag(:span, 'wallet', class: 'badge badge-success')
                end
              when PaymentAddress
                link_to payment_address_path(owner) do
                  content_tag(:span, 'our deposit address', class: 'badge badge-primary')
                end
              when Withdraw
                link_to withdraw_path(owner) do
                  content_tag(:span, 'external withdraw address', class: 'badge badge-secondary')
                end
              else
                content_tag(:span, 'unknown external address', class: 'badge badge-secondary')
              end
    content_tag(:div, address, class: 'text-monospace') + details
  end
  # rubocop:enable Metrics/MethodLength

  def transaction_status(status)
    css_class = {
      'success' => 'badge badge-success',
      'failure' => 'badge badge-warning',
      'pending' => 'badge badge-secondary'
    }
    content_tag :span, status, class: css_class[status] || 'badge badge-danger'
  end

  def download_link(url = nil, size = nil)
    title = size.present? ? t('helpers.download_with_size', ext: 'xlsx', size: size) : t('helpers.download_without_size', ext: 'xlsx')
    link_to url || url_for(q: params.fetch(:q, {}).permit!.to_hash, format: :xlsx), class: 'text-nowrap' do
      content_tag(:span, '⬇', class: 'mr-1') + title
    end
  end
end
