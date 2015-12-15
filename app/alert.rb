class Alert
  attr_reader :description, :url, :service_type, :color

  def initialize
    @description = ''
    @url = ''
    @service_type = ''
    @color = ''
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
end
