class Alert
  attr_reader :description, :url, :start, :end, :services

  @@date_only_length = 8  # YYYYMMDD
  @@date_time_length = 14 # YYYYMMDD HH:MM

  def initialize
    @description = ''
    @url = ''
    @start = ''
    @end = ''
    @services = []
  end

  def description_append(string)
    @description << string
  end

  def url_append(string)
    @url << string
  end

  def start_append(string)
    @start << string
  end

  def end_append(string)
    @end << string
  end

  def add_service(service)
    @services << service
  end

  def affects_trains?
    @services.any? { |service| service.type.include?('Train') }
  end

  def start_string
    # if we're in the middle of the alert time window, make the start 'Now'
    now = NSDate.date
    return 'Now' if start_nsdate <= now && end_nsdate >= now

    convert_to_string(start_nsdate, @start.length, 'Now')
  end

  def end_string
    convert_to_string(end_nsdate, @end.length, 'TBD')
  end

  private

  def start_nsdate
    @start_nsdate ||= convert_to_nsdate(@start)
  end

  def end_nsdate
    @end_nsdate ||= convert_to_nsdate(@end)
  end

  def convert_to_nsdate(time_str)
    if time_str.length == @@date_only_length
      date_only_parser.dateFromString(time_str)
    elsif time_str.length == @@date_time_length
      date_time_parser.dateFromString(time_str)
    else
      NSDate.date
    end
  end

  def convert_to_string(nsdate, str_length, str_for_empty)
    return date_time_formatter.stringFromDate(nsdate).downcase if str_length == @@date_time_length
    return date_only_formatter.stringFromDate(nsdate) if str_length == @@date_only_length
    str_for_empty
  end

  def date_time_parser
    @@date_time_parser ||= begin
      formatter = NSDateFormatter.alloc.init
      formatter.dateFormat = 'yyyyMMdd HH:mm'
      formatter.timeZone = NSTimeZone.localTimeZone
      formatter
    end
  end

  def date_time_formatter
    @@date_time_formatter ||= begin
      formatter = NSDateFormatter.alloc.init
      formatter.dateFormat = 'M/d ha'
      formatter.timeZone = NSTimeZone.localTimeZone
      formatter
    end
  end

  def date_only_parser
    @@date_only_parser ||= begin
      formatter = NSDateFormatter.alloc.init
      formatter.dateFormat = 'yyyyMMdd'
      formatter.timeZone = NSTimeZone.localTimeZone
      formatter
    end
  end

  def date_only_formatter
    @@date_only_formatter ||= begin
      formatter = NSDateFormatter.alloc.init
      formatter.dateFormat = 'M/d'
      formatter.timeZone = NSTimeZone.localTimeZone
      formatter
    end
  end
end
