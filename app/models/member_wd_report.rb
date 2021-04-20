class MemberWdReport < Report
  def self.form_class
    MemberRecordsForm
  end

  def results
    {
      records: records,
      member: form_object.member
    }
  end

  def perform_async
    update results: {}, status: :success, processed_at: Time.zone.now
  end

  def records
    (Deposit.ransack(q).result + Withdraw.ransack(q).result).sort_by { |r| -r.created_at.to_i }
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
