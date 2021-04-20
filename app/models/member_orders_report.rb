class MemberOrdersReport < Report
  def self.form_class
    MemberOrdersForm
  end

  def results
    {
      orders: Order.ransack(q).result,
      member: form_object.member_id.present? ? Member.find(form_object.member_id) : nil
    }
  end

  def perform_async
    update results: {}, status: :success, processed_at: Time.zone.now
  end

  private

  def q
    { member_id_eq: form_object.member_id, created_at_gt: form_object.time_from, created_at_lteq: form_object.time_to }
  end


  class Generator < BaseGenerator
    def perform
      { }
    end
  end
end
