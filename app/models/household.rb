class Household < ActiveRecord::Base
  has_many :users
  has_many :power_records
  has_many :gas_records

  NAME_COMBINATIONS = {
    "power_records_amount" => "Electricity usage",
    "power_records_carbon_result" => "CO2 generated",
    "power_records_carbon_intensity" => "Carbon intensity",
    "power_records_price" => "Energy price",
    "power_records_energy_cost" => "Energy cost",
    "gas_records_amount" => "Gas usage",
    "gas_records_carbon_result" => "CO2 generated"
  }

  UNIT_COMBINATIONS = {
    "amount" => {
      "day" => { "unit" => "Wh", "divider" => 1 },
      "month" => { "unit" => "kWh", "divider" => 1000 },
      "year" => { "unit" => "MWh", "divider" => 1000000 },
      "all" => { "unit" => "MWh", "divider" => 1000000 },
    },
    "carbon_result" => {
      "day" => { "unit" => "grams CO2", "divider" => 1 },
      "month" => { "unit" => "kg CO2", "divider" => 1000 },
      "year" => { "unit" => "kg CO2", "divider" => 1000 },
      "all" => { "unit" => "tons CO2", "divider" => 1000000 },
    },
    "carbon_intensity" => {
      "day" => { "unit" => "grams/kWh", "divider" => 1 },
      "month" => { "unit" => "grams/kWh", "divider" => 1 },
      "year" => { "unit" => "grams/kWh", "divider" => 1 },
      "all" => { "unit" => "grams/kWh", "divider" => 1 },
    },
    "price" => {
      "day" => { "unit" => "pence/kWh", "divider" => 1 },
      "month" => { "unit" => "pence/kWh", "divider" => 1 },
      "year" => { "unit" => "pence/kWh", "divider" => 1 },
      "all" => { "unit" => "pence/kWh", "divider" => 1 },
    },
    "energy_cost" => {
      "day" => { "unit" => "pence", "divider" => 1 },
      "month" => { "unit" => "pounds", "divider" => 100 },
      "year" => { "unit" => "pounds", "divider" => 100 },
      "all" => { "unit" => "pounds", "divider" => 100 },
    }
  }

  COLORS = {
    "amount" => "#89A54E",
    "carbon_intensity" => "#AA4643",
    "carbon_result" => "#89A54E",
    "price" => "#AA4643",
    "energy_cost" => "#4572A7"
  }

  def readings(energy, date, unit, axis="amount", all=false)
    categories = []
    data = []
    # type = energy == "gas" ? "gas_records" : "power_records"
    type = energy
    series_name = NAME_COMBINATIONS["#{type}_#{axis}"]
    units = UNIT_COMBINATIONS[axis][unit]["unit"]
    divider = UNIT_COMBINATIONS[axis][unit]["divider"]
    color = COLORS[axis]
    operation = "sum"

    case unit
    when "day"
      chart_name = date.strftime("%d %B %Y")
      group = "hour"
      frmt_time = "%H:%M"
      child_unit = "all"
      level = 3
    when "month"
      chart_name = date.strftime("%B %Y")
      group = "day"
      frmt_time = "%d"
      child_unit = "day"
      level = 2
    when "year"
      chart_name = date.strftime("%Y")
      group = "month"
      frmt_time = "%B"
      child_unit = "month"
      level = 1
    else
      chart_name = "All time usage"
      group = "year"
      frmt_time = "%Y"
      child_unit = "year"
      level = 0
    end

    case axis 
    when "carbon_intensity"
      operation = "AVG"
    when "price"
      operation = "AVG"
    end

    if unit=="all"
      readings = self.send(type).aggregate_records(group, axis, operation, all)
    else
      readings = self.send(type).within(date, unit).aggregate_records(group, axis, operation, all)
    end
    sum=0
    props = UNIT_COMBINATIONS.keys - ["carbon_intensity", "price"]
    totals = Hash.new(0)
    readings.each do |record|
      record_date = DateTime.strptime(record["period_date"], "%F %T")
      categories << record_date.strftime(frmt_time)
      if all
        results = {}
        props.each do |prop|
          results[prop] = [(record[prop].to_f/UNIT_COMBINATIONS[prop][unit]["divider"]).round(2), UNIT_COMBINATIONS[prop][unit]["unit"]]
          totals[prop] += record[prop].to_f 
        end
      end
      p record.attributes
      p record[axis]
      data << { date: record_date.strftime("%F"),
                y: (record[axis].to_f/divider).round(2),
                results: all ? results : false,
                unit: child_unit,
                level: level-1,
                type: type,
                axis: axis }
    end

    return {
      units: units,
      # make the name be describing - Electricity, CO2, Gas, money
      chart_name: chart_name,
      series_name: series_name  + " " + chart_name,
      data: data,
      categories: categories,
      level: level,
      color: color,
      totals: totals.each{ |k,v| totals[k] = "#{(v/UNIT_COMBINATIONS[k][unit]["divider"]).round(2)} #{UNIT_COMBINATIONS[k][unit]["unit"]}" }
    }    
  end

  # def get_readings_for(energy, from, to, unit="day", with_date = true)
  #   type = energy == "gas" ? "GasRecord" : "PowerRecord"
  #   readings = self.energy_records.where("period_end >= ? AND period_end < ? AND type = ? ", from, to + 1.day, type).order("period_end")
  #   # res = readings.map{|r| r.usage}
  #   time_unit = case unit
  #   when "hour"
  #     :beginning_of_hour
  #   when "day"
  #     :beginning_of_day
  #   when "week"
  #     :beginning_of_week
  #   when "month"
  #     :beginning_of_month
  #   end
  #   if with_date
  #     return readings.group_by{ |u| u.period_end.send(time_unit) }.map {|k,v| [k.to_time.to_i*1000, v.map{|r| r.usage}.sum.round(2)]}
  #   else
  #     return readings.group_by{ |u| u.period_end.send(time_unit) }.map {|k,v| v.map{|r| r.usage}.sum.round(2)}
  #   end
  # end

  # def all_readings(energy)
  #   result = {}
  #   type = energy == "gas" ? "GasRecord" : "PowerRecord"
  #   readings = self.energy_records.where("type = ?", type).order("period_end")

  #   readings.each do |reading|
  #     year = reading.period_end.strftime("%Y")
  #     month = reading.period_end.strftime("%B")
  #     day = reading.period_end.strftime("%d")
  #     hour = reading.period_end.strftime("%H:%M")
  #     usage = reading.usage

  #     result[year] = result[year] || {"name" => year, "y" => 0, "drilldown" => {}}
  #     result[year]["drilldown"][month] = result[year]["drilldown"][month] || {"name" => "#{month} #{year}", "y" => 0, "drilldown" => {}}
  #     result[year]["drilldown"][month]["drilldown"][day] = result[year]["drilldown"][month]["drilldown"][day] || {"name" => "#{day} #{month} #{year}", "y" => 0, "drilldown" => {}}
      
  #     result[year]["y"] += usage
  #     result[year]["drilldown"][month]["y"] += usage
  #     result[year]["drilldown"][month]["drilldown"][day]["y"] += usage

  #     result[year]["drilldown"][month]["drilldown"][day]["drilldown"][hour] = usage
  #   end
  #   return format_result result
  # end

  # def format_result(result)
  #   data = []
  #   result.each do |year, v1|
  #     data << v1
  #   end
  #   data.each do |year|
  #     drilldown = {}
  #     drilldown["name"] = year["name"]
  #     drilldown["categories"] = year["drilldown"].keys
  #     drilldown["level"] = 1
  #     drilldown["data"] = [] #??
  #     year["drilldown"].each do |_month, month|
  #       drilldown2 = {}
  #       drilldown2["name"] = month["name"]
  #       drilldown2["categories"] = month["drilldown"].keys
  #       drilldown2["level"] = 2
  #       drilldown2["data"] = []
  #       month["drilldown"].each do |_day, day|
  #         drilldown3 = {}
  #         drilldown3["name"] = day["name"]
  #         drilldown3["categories"] = day["drilldown"].keys
  #         drilldown3["level"] = 3
  #         drilldown3["data"] = day["drilldown"].values
  #         drilldown2["data"] << {"y" => day["y"], "drilldown" => drilldown3}
  #       end
  #       drilldown["data"] << {"y" => month["y"], "drilldown" => drilldown2}
  #     end
  #     year["drilldown"] = drilldown
  #   end
  # end

  # def measuring_units(max, type)
  #   case type
  #   when "energy_records"
  #     if max > 
  #   when "gas_records"

  #   when "carbon_records"
      
  #   end
      
  # end
end