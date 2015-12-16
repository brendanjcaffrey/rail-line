class AlertXMLParserDelegate
  attr_reader :alerts

  def initialize
    @alerts = []
    @alert = nil
  end

  def parser(parser, didStartElement: name, namespaceURI: uri, qualifiedName: qual_name, attributes: attrs)
    @last = name

    if name == 'Alert'
      @alerts << @alert if @alert
      @alert = Alert.new
    end
  end

  def parser(parser, foundCharacters: string)
    case @last
    when 'ShortDescription'
      @alert.description_append(string)
    when 'AlertURL'
      @alert.url_append(string)
    when 'ServiceTypeDescription'
      @alert.service_type_append(string)
    when 'ServiceBackColor'
      @alert.color_append(string)
    when 'EventStart'
      @alert.event_start_append(string)
    end
  end
end
