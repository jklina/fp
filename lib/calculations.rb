require "statistics2"

module Calculations
  def self.statistics(values)
    count = values.size
    mean = count > 0 ? self.mean(values) : nil
    std_dev = self.standard_deviation(values)
    tvalue = count > 1 ? Statistics2.ptdist(count - 1, 0.05) : nil

    lower_bound = count > 0 && !tvalue.nil? ? mean + tvalue * (std_dev / Math.sqrt(count)) : nil
    upper_bound = count > 0 && !tvalue.nil? ? mean - tvalue * (std_dev / Math.sqrt(count)) : nil

    {
      :lower_bound => lower_bound,
      :mean => mean,
      :upper_bound => upper_bound
    }
  end

  # Initially lifted from http://samdorr.net/blog/2008/10/standard-deviation/
  def self.standard_deviation(values)
    Math.sqrt(self.variance(values))
  end

  def self.variance(values)
    count = values.size.to_f
    mean = self.mean(values)
    values.inject(0) { |sum, v| sum + (v - mean) ** 2 } / count
  end

  def self.mean(values)
    values.inject(0) { |sum, v| sum + v } / values.size.to_f
  end
end
