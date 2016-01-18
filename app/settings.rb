class Settings
  def self.is_favorited?(name)
    list.index(name) != nil
  end

  def self.favorites
    list
  end

  def self.toggle_favorite(name)
    if is_favorited?(name)
      update_list(list - [name])
    else
      update_list((list + [name]).sort)
    end
  end

  private

  def self.list
    NSUserDefaults.standardUserDefaults.objectForKey('favorites') || []
  end

  def self.update_list(list)
    # update the 3D touch app shortcuts with up to the four stations (reverse so A is at top, Z is at bottom)
    shortcuts = list[0..3].reverse.map do |item|
      UIApplicationShortcutItem.alloc.initWithType(item, localizedTitle: item, localizedSubtitle: '',
        icon: UIApplicationShortcutIcon.iconWithType(UIApplicationShortcutIconTypeFavorite), userInfo: {})
    end
    UIApplication.sharedApplication.shortcutItems = shortcuts

    NSUserDefaults.standardUserDefaults.setObject(list, forKey: 'favorites')
  end
end
