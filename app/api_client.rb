class APIClient
  def self.get_etas(station_id)
    url = 'http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=%s&mapid=%d' % [Secrets.api_key, station_id]
    error_ptr = Pointer.new(:object)
    data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options: NSDataReadingUncached, error: error_ptr)

    return nil if !data

    delegate = ArrivalXMLParserDelegate.new
    parser = NSXMLParser.alloc.initWithData(data)
    parser.delegate = delegate
    parser.parse

    delegate.etas.sort
  end

  def self.get_alerts
    url = 'http://www.transitchicago.com/api/1.0/alerts.aspx'
    error_ptr = Pointer.new(:object)
    data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options: NSDataReadingUncached, error: error_ptr)

    return nil if !data

    delegate = AlertXMLParserDelegate.new
    parser = NSXMLParser.alloc.initWithData(data)
    parser.delegate = delegate
    parser.parse

    delegate.alerts.select { |alert| alert.affects_trains? }.uniq { |alert| alert.description }
  end
end
