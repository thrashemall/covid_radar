class Formatter
  class << self
    include ActionView::Helpers::NumberHelper

    def number(value)
      number_with_delimiter(value, delimiter: ' ')
    end

    def signed_number(value, zero: '', up: '+', down: '-')
      sign = value.zero? ? zero : nil
      sign ||= value.positive? ? up : down
      "#{sign}#{number(value)}"
    end
  end
end
