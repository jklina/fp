require "statistics2"

module Calculations
  def self.statistics(values)
    statistics = {
      :lower_bound => nil,
      :mean => nil,
      :upper_bound => nil
    }

    mean = self.mean(values)
    statistics[:mean] = mean

    return statistics if values.size <= 1

    count = values.size
    std_dev = self.standard_deviation(values)
    tvalue = Statistics2.ptdist(count - 1, 0.05)

    statistics[:lower_bound] = mean + tvalue * std_dev / Math.sqrt(count)
    statistics[:upper_bound] = mean - tvalue * std_dev / Math.sqrt(count)

    statistics
  end

  # Initially lifted from http://samdorr.net/blog/2008/10/standard-deviation/
  def self.standard_deviation(values)
    return nil if values.empty?

    Math.sqrt(self.variance(values))
  end

  def self.variance(values)
    return nil if values.empty?

    count = values.size.to_f
    mean = self.mean(values)
    values.inject(0) { |sum, v| sum + (v - mean) ** 2 } / count
  end

  def self.mean(values)
    return nil if values.empty?

    values.inject(0) { |sum, v| sum + v } / values.size.to_f
  end
end
