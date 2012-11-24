class Household < ActiveRecord::Base
  has_many :users
  has_many :energy_records

  def get_readings_for(energy, from, to, unit="day")
    type = energy == "gas" ? "GasRecord" : "PowerRecord"
    @readings = self.energy_records.where("period_end >= ? AND period_end < ? AND type = ? ", from, to + 1.day, type).order("period_end")
    # res = @readings.map{|r| r.usage}
    case unit
    when "hour"
      time_unit = :beginning_of_hour
    when "day"
      time_unit = :beginning_of_day
    when "week"
      time_unit = :beginning_of_week
    end
    return @readings.group_by{ |u| u.period_end.send(time_unit) }.map {|k,v| [k.to_time.to_i*1000, v.map{|r| r.usage}.sum.round(2)]}
  end
end