class AlertXMLParserDelegate
  attr_reader :alerts

  def initialize
    @alerts = []
    @alert = nil
  end

  def parser(parser, didStartElement: name, namespaceURI: uri, qualifiedName: qual_name, attributes: attrs)
    @last = name

    case name
    when 'Alert'
      @alert = Alert.new
    when 'Service'
      @service = Service.new
    end
  end

  def parser(parser, didEndElement: name, namespaceURI: uri, qualifiedName: qual_name)
    case name
    when 'Alert'
      @alerts << @alert
      @alert = nil
    when 'Service'
      @alert.add_service(@service)
      @service = nil
    end
  end

  def parser(parser, foundCharacters: string)
    case @last
    when 'ShortDescription'
      @alert.description_append(string)
    when 'AlertURL'
      @alert.url_append(string)
    when 'EventStart'
      @alert.event_start_append(string)
    when 'ServiceName'
      @service.name_append(string)
    when 'ServiceTypeDescription'
      @service.type_append(string)
    when 'ServiceBackColor'
      @service.color_append(string)
    end
  end
end
