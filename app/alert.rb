class Alert
  attr_reader :description, :url, :event_start, :services

  def initialize
    @description = ''
    @url = ''
    @event_start = ''
    @services = []
  end

  def description_append(string)
    @description << string
  end

  def url_append(string)
    @url << string
  end

  def event_start_append(string)
    @event_start << string
  end

  def add_service(service)
    @services << service
  end

  def is_happening_now?
    return false unless @event_start.include?(':')

    @@formatter ||= begin
      formatter = NSDateFormatter.alloc.init
      formatter.dateFormat = 'yyyyMMdd HH:mm'
      formatter.timeZone = NSTimeZone.localTimeZone
      formatter
    end

    start = @@formatter.dateFromString(@event_start)
    start <= Time.now
  end

  def affects_trains?
    @services.any? { |service| service.type.include?('Train') }
  end
end
