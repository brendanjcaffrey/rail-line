class ETACellView < UITableViewCell
  def initWithStyle(style, reuseIdentifier: identifier)
    super
    @layout = ETACellLayout.new(root: WeakRef.new(self)).build
    self.selectionStyle = UITableViewCellSelectionStyleNone
    self
  end

  def update(eta)
    @layout.color.backgroundColor = CTAInfo.colors[eta.route]
    @layout.time.textColor = CTAInfo.colors[eta.route]
    @layout.time.text = eta.time_string
    @layout.destination.textColor = CTAInfo.colors[eta.route]
    @layout.destination.text = eta.destination
  end
end
