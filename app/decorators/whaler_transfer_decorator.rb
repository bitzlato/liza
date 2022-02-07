class WhalerTransferDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id user_id member amount currency_code source destination description state log created_at updated_at]
  end

  def log
    buffer = h.content_tag :span, Array.wrap(object.log).last&.dig('message')
    buffer << h.button_tag('more', class: 'btn btn-link', data: { toggle: 'popover' })
  end

  def member
    member = Member.find_by(uid: object.member_uid)
    h.link_to "#{member&.email}(#{object.member_uid})", h.member_path(object.member_uid)
  end

  def state
    badge_class = h.class_names('badge', 'badge-success': object.successful?, 'badge-danger': object.fail?, 'badge-secondary': (!object.successful? && !object.fail?))
    h.content_tag :span, object.state, class: badge_class
  end
end
