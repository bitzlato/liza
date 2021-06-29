# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'net/http'

module OpendaxHelper
  def present_peatio_version
    content_tag :span, '', class: 'mr-2 text-small', data: { 'api-version' => true, prefix: 'peatio: ', url: peatio_version_url }
  end

  def present_barong_version
    content_tag :span, '', class: 'mr-2 text-small', data: { 'api-version' => true, prefix: 'barong: ', url: barong_version_url }
  end

  def peatio_version_url
    "#{Settings.peatio_api_url}/public/version"
  end

  def barong_version_url
    "#{Settings.barong_api_url}/public/version"
  end

  def peatio_version
    Rails.cache.fetch :peatio_version do
      JSON.parse Net::HTTP.get(URI(peatio_version_url))
    rescue StandardError => e
      Rails.logger.error e
      Bugsnag.notify e
      {}
    end
  end

  def barong_version
    Rails.cache.fetch :barong_version do
      JSON.parse Net::HTTP.get(URI(barong_version_url))
    rescue StandardError => e
      Rails.logger.error e
      Bugsnag.notify e
      {}
    end
  end
end
