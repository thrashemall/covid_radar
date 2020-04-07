module Bot
  class CommandsController < BotController
    def country
      with_bot do |bot|
        country_question.track
        country_question.reply(bot)
      end
    end

    def chart
      with_bot do |bot|
        chart_question.track
        chart_question.reply(bot)
      end
    end

    def compare
      with_bot do |bot|
        compare_question.track
        compare_question.reply(bot)
      end
    end

    def top
      with_bot do |bot|
        top_answer.reply(bot)
      end
    end

    def about
      with_bot do |bot|
        about_answer.reply(bot)
      end
    end

    def not_found
      with_bot do |bot|
        start_answer.reply(bot)
      end
    end

    private

    def country_question
      @country_question ||= CountryQuestion.controller(self)
    end

    def chart_question
      @chart_question ||= ChartQuestion.controller(self)
    end

    def compare_question
      @compare_question ||= CompareQuestion.controller(self)
    end

    def top_answer
      @top_answer ||= TopAnswer.controller(self)
    end

    def start_answer
      @start_answer ||= StartAnswer.controller(self)
    end

    def about_answer
      @about_answer ||= AboutAnswer.controller(self)
    end
  end
end
