class Settings
  FAVORITES_KEY = 'favorites'

  def self.is_favorited?(id)
    list.index(id) != nil
  end

  def self.favorites
    list
  end

  def self.toggle_favorite(id)
    if is_favorited?(id)
      update_list(list - [id])
    else
      update_list((list + [id]).sort)
    end
  end

  private

  def self.list
    NSUserDefaults.standardUserDefaults.objectForKey(FAVORITES_KEY) || []
  end

  def self.update_list(list)
    # update the 3D touch app shortcuts with up to the four stations (reverse so A is at top, Z is at bottom)
    shortcuts = list[0..3].reverse.map do |id|
      station = CTAInfo.stations[id]
      icon = UIApplicationShortcutIcon.iconWithType(UIApplicationShortcutIconTypeFavorite)
      UIApplicationShortcutItem.alloc.initWithType(id.to_s, localizedTitle: station.name,
        localizedSubtitle: '', icon: icon, userInfo: {})
    end
    UIApplication.sharedApplication.shortcutItems = shortcuts

    NSUserDefaults.standardUserDefaults.setObject(list, forKey: FAVORITES_KEY)
  end
end
