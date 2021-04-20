class MemberOrdersForm < TimeRangeForm
  attr_accessor :member_id

  def member
    return if member_id.nil?
    Member.find_by id: member_id
  end
end
