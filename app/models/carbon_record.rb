class CarbonRecord < Record
  def self.for(date)
    if record = self.find_by_period_end(date.beginning_of_hour)
      return record.amount
    else
      return self.where("period_end >= ? AND period_end < ?", date, date + 1.month).group("date_trunc('month', period_end)").average(:amount).values.last.to_f.round(2)
    end
  end
end