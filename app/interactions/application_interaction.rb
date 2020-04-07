# frozen_string_literal: true

class ApplicationInteraction
  REDIS_KEY = 'app:interaction:%<id>d'
  REDIS_LIMIT = 10

  attr_reader :message
  attr_reader :json

  delegate :text, :chat, to: :message, prefix: true

  def self.controller(controller)
    new(message: controller.message)
  end

  def initialize(message: nil, json: {})
    @message = message
    @json = json
  end

  def as_json(*)
    { klass: self.class.to_s, json: json }
  end

  def reply(_api)
    raise NotImplementedError, __method__
  end

  # Add this interaction to user's history
  def track
    Redis.current.multi do
      Redis.current.lpush(redis_key, to_json)
      Redis.current.ltrim(redis_key, 0, REDIS_LIMIT)
    end
  end

  def before(limit = REDIS_LIMIT)
    Redis.current.lrange(redis_key, 0, limit).map do |data|
      json = JSON.parse(data)
      json['klass'].constantize.new(json: json['json'])
    end
  end

  # @return [self] latest interaction with user
  def final
    before(0).first
  end

  private

  def redis_key
    @redis_key ||= format(REDIS_KEY, id: message_chat.id)
  end
end
