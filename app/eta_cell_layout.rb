class ETACellLayout < MK::Layout
  @@cell_height = 44
  @@color_spacing = 1
  @@color_height = @@cell_height - @@color_spacing
  @@color_width = 20
  @@spacing = 8
  @@font_size = 24

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
      left.equals(:superview).priority(1000)
    end
  end

  def destination_style
    font UIFont.systemFontOfSize(@@font_size)
    text_alignment NSTextAlignmentLeft

    constraints do
      height.equals(@@cell_height)
      left.equals(:color, :right).plus(@@spacing).priority(1000)
    end
  end

  def time_style
    font UIFont.systemFontOfSize(@@font_size)
    text_alignment NSTextAlignmentRight

    constraints do
      height.equals(@@cell_height)
      right.equals(:superview, :right).minus(@@spacing).priority(1000)
      left.equals(:destination, :right)
    end
  end
end
