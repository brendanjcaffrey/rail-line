class Colors
  def self.cyan
    UIColor.colorWithRed(0.0, green: 187.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
  end

  def self.faded_cyan
    UIColor.colorWithRed(37.0 / 255.0, green: 200.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
  end

  def self.white
    UIColor.whiteColor
  end

  class << self ; attr_reader :routes, :route_colors ; end

  @routes = {
    'Red' => 'Red',
    'Blue' => 'Blue',
    'Brn' => 'Brown',
    'G' => 'Green',
    'Org' => 'Orange',
    'P' => 'Purple',
    'Pink' => 'Pink',
    'Y' => 'Yellow'
  }

  @route_colors = {
    'Red'    => UIColor.colorWithRed(198.0 / 255.0, green: 12.0  / 255.0, blue: 48.0  / 255.0, alpha: 1.0),
    'Blue'   => UIColor.colorWithRed(0.0   / 255.0, green: 161.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0),
    'Brown'  => UIColor.colorWithRed(98.0  / 255.0, green: 54.0  / 255.0, blue: 27.0  / 255.0, alpha: 1.0),
    'Green'  => UIColor.colorWithRed(0.0   / 255.0, green: 155.0 / 255.0, blue: 58.0  / 255.0, alpha: 1.0),
    'Orange' => UIColor.colorWithRed(249.0 / 255.0, green: 71.0  / 255.0, blue: 28.0  / 255.0, alpha: 1.0),
    'Purple' => UIColor.colorWithRed(82.0  / 255.0, green: 35.0  / 255.0, blue: 152.0 / 255.0, alpha: 1.0),
    'Pink'   => UIColor.colorWithRed(226.0 / 255.0, green: 126.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0),
    'Yellow' => UIColor.colorWithRed(249.0 / 255.0, green: 227.0 / 255.0, blue: 0.0   / 255.0, alpha: 1.0)
  }
end
