class Record < ActiveRecord::Base
  belongs_to :household
  # scope :aggregate_records, lambda{|group, unit_divider, child_unit, level| group("#{group}(period_end)").select("DATE_FORMAT(period_end, '%Y-%m-%d') as date, ROUND(SUM(amount)/#{unit_divider}, 2) as y, '#{child_unit}' as unit, '#{level-1}' as level") }
  scope :within, lambda{|date, unit| where("period_end >= ? AND period_end < ?", date, date + 1.send(unit))}

  def self.aggregate_records(group)
    group("#{group}(period_end)")
      .select(%{period_end as date, 
                SUM(amount) as y}).order(:period_end)
  end
end