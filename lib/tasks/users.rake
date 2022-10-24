# frozen_string_literal: true

namespace :users do
  desc 'Export active peatio users'
  task export_peatio: :environment do
    CSV.open('tmp/peatio_users.csv', 'w') do |csv|
      Member.find_each do |member|
        bitzlato_user = BitzlatoUser.where('LOWER(real_email) = ?', member.email.downcase).where(email_verified: true, deleted_at: nil).take
        next if bitlzato_user.present? && (!bitzlato_user.email_verified? || !bitzlato_user.deleted_at.nil?)

        csv << [member.email, bitzlato_user&.telegram_id]
      end
    end
  end
end
