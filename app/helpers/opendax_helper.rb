require 'net/http'

module OpendaxHelper

  def present_peatio_version
    'Peatio: ' + peatio_version['build_date'] + '#' + peatio_version['git_sha']
  end

  def present_barong_version
    'Barong: ' + barong_version['build_date'] + '#' + barong_version['git_sha']
  end

  def peatio_version
    Rails.cache.fetch :peatio_version do
      JSON.parse Net::HTTP.get(URI(Settings.peatio_api_url + '/public/version'))
    end
  end

  def barong_version
    Rails.cache.fetch :barong_version do
      JSON.parse Net::HTTP.get(URI(Settings.barong_api_url + '/public/version'))
    end
  end
end
