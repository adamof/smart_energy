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

  UNITS=["day", "month", "year", "all"]

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
                chart_name: chart_name,
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
      totals: totals.each{ |k,v| totals[k] = "#{(v/UNIT_COMBINATIONS[k][next_unit(unit)]["divider"]).round(2)} #{UNIT_COMBINATIONS[k][next_unit(unit)]["unit"]}" }
    }    
  end

  private
  def next_unit(unit)
    return "all" if unit=="all"
    UNITS[(UNITS.index(unit)+1)%UNITS.length]
  end
end