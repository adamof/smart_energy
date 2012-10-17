class Household < ActiveRecord::Base
  has_many :users
  has_many :energy_records
end