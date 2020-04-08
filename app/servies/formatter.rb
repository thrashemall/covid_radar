class Formatter
  class << self
    include ActionView::Helpers::NumberHelper

    def number(value)
      number_with_delimiter(value, delimiter: ' ')
    end

    def percentage(value)
      number_to_percentage(value, strip_insignificant_zeros: true)
    end

    # @example
    #   signed_number(10) do |value|
    #     percentage(value)
    #   end
    def signed_number(value, zero: '', up: '+', down: '-')
      sign = value.zero? ? zero : nil
      sign ||= value.positive? ? up : down
      "#{sign}#{yield(value.abs)}"
    end
  end
end
