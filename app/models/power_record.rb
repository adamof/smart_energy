class PowerRecord < Record
  before_save :calc_carbon#, :if => :amount_changed?
  before_save :calc_cost#, :if => :amount_changed?

  def calc_carbon
    self.carbon_intensity = CarbonRecord.for(self.period_end)
    self.carbon_result = (self.carbon_intensity * self.amount)/1000.0
  end  

  def calc_cost
    self.price = 12
    self.cost = (self.price * self.amount)/1000.0
  end  
end