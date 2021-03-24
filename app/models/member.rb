# encoding: UTF-8
# frozen_string_literal: true

require 'securerandom'

class Member < ApplicationRecord
  scope :enabled, -> { where(state: 'active') }

  def role
    super&.inquiry
  end

  def admin?
    role == "admin"
  end

  private

  class << self
    def uid(member_id)
      Member.find_by(id: member_id)&.uid
    end

    def find_by_username_or_uid(uid_or_username)
      if Member.find_by(uid: uid_or_username).present?
        Member.find_by(uid: uid_or_username)
      elsif Member.find_by(username: uid_or_username).present?
        Member.find_by(username: uid_or_username)
      end
    end
  end
end
