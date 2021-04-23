# frozen_string_literal: true

require 'net/http'

module OpendaxHelper

  def present_peatio_version
    return link_to 'peatio version', peatio_version_url, target: '_blank'
    "Peatio: #{peatio_version['build_date']}##{peatio_version['git_sha']}"
  end

  def present_barong_version
    return link_to 'barong version', barong_version_url, target: '_blank'
    "Barong: #{barong_version['build_date']}##{barong_version['git_sha']}"
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
    rescue => err
      Rails.logger.error err
      Bugsnag.notify err
      {}
    end
  end

  def barong_version
    Rails.cache.fetch :barong_version do
      JSON.parse Net::HTTP.get(URI(barong_version_url))
    rescue => err
      Rails.logger.error err
      Bugsnag.notify err
      {}
    end
  end
end
