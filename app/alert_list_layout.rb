class AlertListLayout < MK::Layout
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
    table_footer_view UIView.alloc.initWithFrame(CGRectZero)

    estimated_row_height 44.0
    row_height UITableViewAutomaticDimension

    constraints do
      @top_constraint = top.equals(:superview)
      @bottom_constraint = bottom.equals(:superview)
      left.equals(:superview)
      right.equals(:superview)
    end
  end
end
