class WhalerTransferDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id user_id member amount currency_code source destination description state last_log_message created_at updated_at]
  end

  def last_log_message
    Array.wrap(object.log).last&.dig('message')
  end

  def member
    member = Member.find_by(uid: object.member_uid)
    h.link_to "#{member.email}(#{member.uid})", h.member_path(member)
  end

  def state
    badge_class = h.class_names('badge', 'badge-success': object.successful?, 'badge-danger': object.fail?, 'badge-secondary': (!object.successful? && !object.fail?))
    h.content_tag :span, object.state, class: badge_class
  end
end
