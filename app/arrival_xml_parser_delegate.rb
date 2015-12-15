class ArrivalXMLParserDelegate
  attr_reader :etas

  def initialize
    @etas = []
    @eta = nil
  end

  def parser(parser, didStartElement: name, namespaceURI: uri, qualifiedName: qual_name, attributes: attrs)
    @last = name

    if name == 'eta'
      @etas << @eta if @eta
      @eta = ETA.new
    end
  end

  def parser(parser, foundCharacters:string)
    case @last
    when 'destNm'
      @eta.dest_append(string)
    when 'rt'
      @eta.rt_append(string)
    when 'isApp'
      @eta.app_append(string)
    when 'arrT'
      @eta.arr_append(string)
    when 'prdt'
      @eta.prd_append(string)
    end
  end
end
