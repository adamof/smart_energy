class Record < ActiveRecord::Base
  belongs_to :household
  scope :within, lambda{|date, unit| where("period_end >= ? AND period_end < ?", date, date + 1.send(unit))}

  def self.aggregate_records(group, column, operation="SUM")
    group("date")
      .select(%{DISTINCT ON (date) #{operation}(#{column}) y, 
                date_trunc('#{group}', period_end) date}).order("date")
  end
end