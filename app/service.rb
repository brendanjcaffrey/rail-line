class Service
  attr_reader :name, :type, :color

  def initialize
    @name = ''
    @type = ''
    @color = ''
  end

  def name_append(string)
    @name << string
  end

  def type_append(string)
    @type << string
  end

  def color_append(string)
    @color << string
  end

  def uicolor
    return UIColor.blackColor if @color.length < 6

    red = @color[0..1].to_i(16).to_f / 255.0
    green = @color[2..3].to_i(16).to_f / 255.0
    blue = @color[4..5].to_i(16).to_f / 255.0

    UIColor.colorWithRed(red, green: green, blue: blue, alpha: 1.0)
  end
end
