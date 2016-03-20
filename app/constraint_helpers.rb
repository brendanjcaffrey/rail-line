module LayoutConstraintHelper
  module_function

  def update_constraint(controller)
    @extra_bottom_space ||= 0

    @top_constraint.equals(controller.topLayoutGuide.length) if controller.topLayoutGuide.length != 0
    bottom = -1 * (controller.bottomLayoutGuide.length + @extra_bottom_space)
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
        @layout.update_extra_bottom_space(self, kb_height)
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
