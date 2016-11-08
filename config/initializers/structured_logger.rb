class ActiveSupport::StructuredLogger < StructuredLogger
  include ActiveSupport::LoggerThreadSafeLevel
  include LoggerSilence

  def initialize(*args)
    super
    @formatter = ActiveSupport::Logger::SimpleFormatter.new
    after_initialize if respond_to? :after_initialize
  end
end

l = ActiveSupport::StructuredLogger.new("log/#{Rails.env}.log")
l.formatter = ::Logger::Formatter.new
l = ActiveSupport::TaggedLogging.new(l)
Rails.logger = l
