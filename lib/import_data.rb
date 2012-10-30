module ImportData
  def self.delete_data
    Household.delete_all
    EnergyRecord.delete_all
  end
  def self.init(n=nil)
    self.delete_data
    self.import_usage("readings.xls", n)
  end
  def self.import_usage(file, n_households=0)
    s = Excel.new(file)
    last_record = nil
    2.upto(s.last_row) do |line|
      household = s.cell(line,'A')
      usage     = s.cell(line,'B')
      date      = s.cell(line,'C')
      puts "#{line}: #{household}, #{usage}, #{date}"
      household = Household.find_or_create_by_name(household)
      if Household.count==n_households+1
        household.delete
        break
      end
      distribution = (rand(3) + 4).to_f
      this = EnergyRecord.create household: household, 
                              usage: (10 - distribution)*usage/10,
                              period_end: date.asctime
      if last_record and last_record.household == household
        if this.period_end - last_record.period_end > 3600
          last_record = EnergyRecord.create household: household, 
                              usage: (usage + last_record.usage)/2.0,
                              period_end: date-1.hour
        end
        EnergyRecord.create household: household, 
                            usage: distribution*usage/10,
                            period_end: date-30.minutes
      end
      last_record = this
    end
  end
  def fix_data
    
  end
end
