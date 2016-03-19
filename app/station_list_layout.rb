class StationListLayout < MK::Layout
  include LayoutConstraintHelper
  view :search, :table

  def layout
    root :root do
      add UISearchBar, :search
      add UITableView, :table
    end
  end

  def root_style
    background_color Colors.white
  end

  def search_style
    placeholder 'Search'
    tint_color Colors.cyan

    constraints do
      @top_constraint = top.equals(:superview)
      left.equals(:superview)
      right.equals(:superview)
    end
  end

  def table_style
    tint_color Colors.cyan

    constraints do
      top.equals(:search, :bottom)
      @bottom_constraint = bottom.equals(:superview)
      left.equals(:superview)
      right.equals(:superview)
    end
  end
end
