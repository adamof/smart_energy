class Record < ActiveRecord::Base
  belongs_to :household
  scope :within, lambda{|date, unit| where("period_end >= ? AND period_end < ?", date, date + 1.send(unit))}

  def self.aggregate_records(group, column, operation="SUM")
    group("#{group}(period_end)")
      .select(%{period_end as date, 
                #{operation}(#{column}) as y}).order(:period_end)
  end
end