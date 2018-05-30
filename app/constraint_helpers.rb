module LayoutConstraintHelper
  module_function

  def update_constraint(controller)
    @extra_bottom_space ||= 0

    @top_constraint.equals(controller.topLayoutGuide.length) if controller.topLayoutGuide.length != 0
    bottom = -1 * (controller.bottomLayoutGuide.length + @extra_bottom_space) + self.view.safeAreaInsets.bottom
    @bottom_constraint.equals(bottom)
    self.view.layoutIfNeeded
  end

  def update_extra_bottom_space(controller, extra_bottom_space)
    @extra_bottom_space = extra_bottom_space
    update_constraint(controller)
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

  def setup_keyboard_listeners
    @observers ||= []
    @observers << NSNotificationCenter.defaultCenter.addObserverForName(
      UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue,
      usingBlock: ->(notification) {
        kb_frame = notification.userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey).CGRectValue
        kb_height = view.convertRect(kb_frame, fromView: view.window).size.height
        @layout.update_extra_bottom_space(self, kb_height-view.safeAreaInsets.bottom)
      })
    @observers << NSNotificationCenter.defaultCenter.addObserverForName(
        UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue,
        usingBlock: ->(notification) { @layout.update_extra_bottom_space(self, 0) })
  end

  def remove_keyboard_listeners
    (@observers || []).each { |obs| NSNotificationCenter.defaultCenter.removeObserver(obs) }
    @observers = []
  end
end

module ManualConstraintHelper
  module_function

  def viewWillAppear
    update_constraint
    super
  end

  def updateViewConstraints
    update_constraint
    super
  end

  def didRotateFromInterfaceOrientation(orientation)
    update_constraint
    super
  end

  def update_constraint
    @top_constraint.constant = topLayoutGuide.length - view.safeAreaInsets.top
    @height_constraint.constant = -1 * (bottomLayoutGuide.length + topLayoutGuide.length - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
  end

  def build_constraint(for_attr)
    NSLayoutConstraint.constraintWithItem(@map, attribute: for_attr, relatedBy: NSLayoutRelationEqual, toItem: view, attribute: for_attr, multiplier: 1, constant: 0)
  end
end

