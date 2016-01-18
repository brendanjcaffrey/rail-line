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
    NSUserDefaults.standardUserDefaults.setObject(list, forKey: 'favorites')
  end
end
