module Calculations
  # Lifted from http://samdorr.net/blog/2008/10/standard-deviation/
  def self.standard_deviation(values)
    count = values.size.to_f
    mean = values.inject(0) { |sum, v| sum + v } / count
    Math.sqrt(values.inject(0) { |sum, v| sum + (v - mean) ** 2 } / count)
  end
end
