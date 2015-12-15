class ETACellLayout < MK::Layout
  @@cell_height = 44
  @@color_spacing = 1
  @@color_height = @@cell_height - @@color_spacing
  @@color_width = 20
  @@half_color_width = @@color_width / 2.0
  @@spacing = 8
  @@font_size = 28
  @@time_percent_width = 0.40
  @@destination_percent_width = 1.0 - @@time_percent_width

  view :color, :destination, :time

  def layout
    root :cell do
      add UIView, :color
      add UILabel, :destination
      add UILabel, :time
    end
  end

  def cell_style
    background_color UIColor.whiteColor
  end

  def color_style
    constraints do
      top.equals(0)
      width.equals(@@color_width)
      height.equals(@@color_height)
    end
  end

  def destination_style
    font UIFont.systemFontOfSize(@@font_size)
    text_alignment NSTextAlignmentLeft

    constraints do
      height.equals(@@cell_height)
      left.equals(:color, :right).plus(@@spacing)
      width.equals(:superview).times(@@destination_percent_width).minus(@@half_color_width)
    end
  end

  def time_style
    font UIFont.systemFontOfSize(@@font_size)
    text_alignment NSTextAlignmentRight

    constraints do
      height.equals(@@cell_height)
      right.equals(:superview, :right).minus(@@spacing)
      width.equals(:superview).times(@@time_percent_width).minus(@@half_color_width)
    end
  end
end
