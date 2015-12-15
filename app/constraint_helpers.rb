module LayoutConstraintHelper
  module_function

  def update_constraint(controller)
    @top_constraint.equals(controller.topLayoutGuide.length) if controller.topLayoutGuide.length != 0
    @bottom_constraint.equals(-1 * controller.bottomLayoutGuide.length) if controller.bottomLayoutGuide.length != 0
    self.view.layoutIfNeeded
  end
end

module ControllerConstraintHelper
  module_function

  def viewWillAppear
    @layout.update_constraint(self)
    super
  end

  def updateViewConstraints
    @layout.update_constraint(self)
    super
  end

  def didRotateFromInterfaceOrientation(orientation)
    @layout.update_constraint(self)
    super
  end
end
