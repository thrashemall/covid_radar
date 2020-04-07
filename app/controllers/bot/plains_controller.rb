module Bot
  class PlainsController < BotController
    def create
      answer =
        case final
        when CountryQuestion
          CountryAnswer
        when ChartQuestion
          ChartAnswer
        when CompareQuestion
          CompareAnswer
        else
          StartAnswer
        end

      with_bot do |bot|
        answer.controller(self).reply(bot)
      end
    end

    private

    # @return [ApplicationInteraction]
    def final
      ApplicationInteraction.controller(self).final
    end
  end
end
