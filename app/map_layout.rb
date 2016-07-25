class MapLayout < MK::Layout
  include LayoutConstraintHelper
  view :map

  def layout
    root :root do
      add MKMapView, :map
    end
  end

  def root_style
    background_color Colors.white
  end

  def map_style
    map_type MKMapTypeStandard
    shows_user_location true

    constraints do
      @top_constraint = top.equals(:superview)
      @bottom_constraint = bottom.equals(:superview)
      left.equals(:superview)
      right.equals(:superview)
    end
  end
end
