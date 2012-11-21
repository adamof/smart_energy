class Household < ActiveRecord::Base
  has_many :users
  has_many :energy_records

  def get_readings_for(from, to, unit="day")
    @readings = self.energy_records.where("period_end >= ? AND period_end <= ?", from, to).order("period_end")
    # res = @readings.map{|r| r.usage}
    return @readings.group_by{ |u| u.period_end.beginning_of_day }.map {|k,v| v.map{|r| r.usage}.sum}
  end
end