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
      update_list((list + [id]).sort_by { |station_id| CTAInfo.stations[station_id].name })
    end
  end

  def self.verify_stations_on_startup
    Settings.update_list(Settings.list.select { |id| CTAInfo.stations.has_key?(id) })
  end

  private

  def self.list
    @list ||= NSUserDefaults.standardUserDefaults.objectForKey(FAVORITES_KEY) || []
  end

  def self.update_list(list)
    # update the 3D touch app shortcuts with up to the four stations (which is the max iOS allows)
    shortcuts = list[0..3].map do |id|
      station = CTAInfo.stations[id]
      icon = UIApplicationShortcutIcon.iconWithType(UIApplicationShortcutIconTypeFavorite)
      UIApplicationShortcutItem.alloc.initWithType(id.to_s, localizedTitle: station.name,
        localizedSubtitle: '', icon: icon, userInfo: {})
    end
    UIApplication.sharedApplication.shortcutItems = shortcuts

    NSUserDefaults.standardUserDefaults.setObject(list, forKey: FAVORITES_KEY)
    @list = list
  end
end
