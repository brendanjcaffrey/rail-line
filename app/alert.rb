class Alert
  attr_reader :description, :url, :service_type, :color

  def initialize
    @description = ''
    @url = ''
    @service_type = ''
    @color = ''
    @event_start = ''
  end

  def description_append(string)
    @description << string
  end

  def url_append(string)
    @url << string
  end

  def service_type_append(string)
    @service_type << string
  end

  def color_append(string)
    @color << string
  end

  def event_start_append(string)
    @event_start << string
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
end
