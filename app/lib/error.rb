module Error
  Covid = Class.new(StandardError)
  CountryNotFound = Class.new(Covid)
  Custom = Class.new(Covid)
end
