class Household < ActiveRecord::Base
  has_many :users
  has_many :energy_records

  def get_readings_for(energy, from, to, unit="day", with_date = true)
    type = energy == "gas" ? "GasRecord" : "PowerRecord"
    readings = self.energy_records.where("period_end >= ? AND period_end < ? AND type = ? ", from, to + 1.day, type).order("period_end")
    # res = readings.map{|r| r.usage}
    case unit
    when "hour"
      time_unit = :beginning_of_hour
    when "day"
      time_unit = :beginning_of_day
    when "week"
      time_unit = :beginning_of_week
    end
    if with_date
      return readings.group_by{ |u| u.period_end.send(time_unit) }.map {|k,v| [k.to_time.to_i*1000, v.map{|r| r.usage}.sum.round(2)]}
    else
      return readings.group_by{ |u| u.period_end.send(time_unit) }.map {|k,v| v.map{|r| r.usage}.sum.round(2)}
    end
  end

  def all_readings(energy)
    result = {}
    type = energy == "gas" ? "GasRecord" : "PowerRecord"
    readings = self.energy_records.where("type = ?", type).order("period_end")

    readings.each do |reading|
      year = reading.period_end.strftime("%Y")
      month = reading.period_end.strftime("%B")
      day = reading.period_end.strftime("%d")
      hour = reading.period_end.strftime("%H:%M")
      usage = reading.usage

      result[year] = result[year] || {"name" => year, "y" => 0, "drilldown" => {}}
      result[year]["drilldown"][month] = result[year]["drilldown"][month] || {"name" => "#{month} #{year}", "y" => 0, "drilldown" => {}}
      result[year]["drilldown"][month]["drilldown"][day] = result[year]["drilldown"][month]["drilldown"][day] || {"name" => "#{day} #{month} #{year}", "y" => 0, "drilldown" => {}}
      
      result[year]["y"] += usage
      result[year]["drilldown"][month]["y"] += usage
      result[year]["drilldown"][month]["drilldown"][day]["y"] += usage

      result[year]["drilldown"][month]["drilldown"][day]["drilldown"][hour] = usage
    end
    return format_result result
  end

  def format_result(result)
    data = []
    result.each do |year, v1|
      data << v1
    end
    data.each do |year|
      drilldown = {}
      drilldown["name"] = year["name"]
      drilldown["categories"] = year["drilldown"].keys
      drilldown["level"] = 1
      drilldown["data"] = [] #??
      year["drilldown"].each do |month, v2|
        drilldown2 = {}
        drilldown2["name"] = v2["name"]
        drilldown2["categories"] = v2["drilldown"].keys
        drilldown2["level"] = 2
        drilldown2["data"] = []
        v2["drilldown"].each do |day, v3|
          drilldown3 = {}
          drilldown3["name"] = v3["name"]
          drilldown3["categories"] = v3["drilldown"].keys
          drilldown3["level"] = 3
          drilldown3["data"] = v3["drilldown"].values
          drilldown2["data"] << {"y" => v3["y"], "drilldown" => drilldown3}
        end
        drilldown["data"] << {"y" => v2["y"], "drilldown" => drilldown2}
      end
      year["drilldown"] = drilldown
    end
  end
end