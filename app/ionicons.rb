module Ionicons
  module_function

  def empty_star  ; 0xf4b2.chr(Encoding::UTF_8) ; end
  def filled_star ; 0xf4b3.chr(Encoding::UTF_8) ; end

  def build_bar_button(target, action, icon_name)
    inset = 5
    font_size = 27.0
    icon = self.send(icon_name)

    image = button_image(icon, font_size)
    highlight = highlighted_button_image(icon, font_size)

    button = UIButton.buttonWithType(UIButtonTypeCustom)
    button.setImage(image, forState: UIControlStateNormal)
    button.setImage(highlight, forState: UIControlStateHighlighted)

    button.frame = CGRectMake(0, 0, image.size.width, image.size.height)
    button.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, inset * -1)
    button.addTarget(target, action: action,
      forControlEvents: UIControlEventTouchUpInside)

    UIBarButtonItem.alloc.initWithCustomView(button)
  end

  def button_image(icon, font_size)
    draw_icon(icon, font_size, Colors.cyan)
  end

  def highlighted_button_image(icon, font_size)
    draw_icon(icon, font_size, Colors.faded_cyan)
  end

  def draw_icon(icon, size, color)
    attrs = {NSFontAttributeName => UIFont.fontWithName('Ionicons', size: size),
             NSForegroundColorAttributeName => color}
    text = NSAttributedString.alloc.initWithString(icon, attributes: attrs)

    UIGraphicsBeginImageContextWithOptions(text.size, false, UIScreen.mainScreen.scale)
    text.drawAtPoint(CGPointMake(0, 0))
    image = UIGraphicsGetImageFromCurrentImageContext().imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    UIGraphicsEndImageContext()

    image
  end
end
