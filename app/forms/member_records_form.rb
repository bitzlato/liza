class MemberRecordsForm < TimeRangeForm
  attr_accessor :member_id

  validates :member_id, presence: true

  def self.reflect_on_association(attribute_name)
    Order.reflect_on_association attribute_name
  end

  def member
    return if member_id.nil?
    Member.find_by id: member_id
  end
end
