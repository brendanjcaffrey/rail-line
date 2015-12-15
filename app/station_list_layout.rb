class StationListLayout < MK::Layout
  include LayoutConstraintHelper
  view :table

  def layout
    root :root do
      add UITableView, :table
    end
  end

  def root_style
    background_color UIColor.whiteColor
  end

  def table_style
    constraints do
      @top_constraint = top.equals(:superview)
      @bottom_constraint = bottom.equals(:superview)
      left.equals(:superview)
      right.equals(:superview)
    end
  end
end
