class WhalerTransferDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id user_id member amount currency_code source destination description state received_at sent_at last_log_message created_at updated_at]
  end

  def self.attributes
    (table_columns + %i[cancel_message] + object_class.attribute_names.map(&:to_sym) - %i[log]).uniq
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

  def received_at
    present_time object.received_at
  end

  def sent_at
    present_time object.sent_at
  end
end
