class Record < ActiveRecord::Base
  belongs_to :household
  scope :within, lambda{|date, unit| where("period_end >= ? AND period_end < ?", date, date + 1.send(unit))}

  def self.aggregate_records(group, column, operation="SUM")
    group("period_date")
      .select(%{DISTINCT ON (period_date) #{operation}(#{column}) y, 
                date_trunc('#{group}', period_end) period_date}).order("period_date")
  end

  # def self.running_sum_records(group, column, operation="SUM")
  #   group("period_date, amount, period_end")
  #     .select(%{DISTINCT ON (period_date) date_trunc('#{group}', period_end) period_date,
  #       #{operation}(#{column}) y,
  #       sum(sum(amount)) over (order by period_end)}).order("period_date")
  # end
end