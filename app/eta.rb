class ETA
  attr_reader :arrival

  def <=>(other)
    @arrival.<=>(other.arrival)
  end

  def initialize
    @destination = ''
    @route = ''
    @approaching = ''
    @arrival = ''
    @generated = ''
  end

  def dest_append(string)
    @destination << string
  end

  def rt_append(string)
    @route << string
  end

  def app_append(string)
    @approaching << string
  end

  def arr_append(string)
    @arrival << string
  end

  def prd_append(string)
    @generated << string
  end

  def destination
    @destination
  end

  def route
    CTAInfo.routes.has_key?(@route) ? CTAInfo.routes[@route] : @route
  end

  def time
    @@formatter ||= begin
      formatter = NSDateFormatter.alloc.init
      formatter.dateFormat = 'yyyyMMdd HH:mm:ss'
      formatter.timeZone = NSTimeZone.localTimeZone
      formatter
    end

    @time ||= begin
      if @approaching == '1'
        0
      else
        arrival = @@formatter.dateFromString(@arrival)
        generated = @@formatter.dateFromString(@generated)
        arrival - generated
      end
    end
  end

  def time_string
    time_min = (time / 60.0).floor
    return 'Due' if @approaching == '1' || time_min < 1
    "#{time_min} min#{time_min == 1 ? '' : 's'}"
  end
end
