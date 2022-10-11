class RescanService
  def self.mutate_data(current_user, new_data)
    current_user.quantityFollowers = new_data[:followers] if new_data[:followers]
    current_user.quantityFollowing = new_data[:following] if new_data[:following]
    current_user.quantityStars = new_data[:stars] if new_data[:stars]
    current_user.lastYearContributions = new_data[:contributions] if new_data[:contributions]
    current_user.avatarUrl = new_data[:avatarUrl] if new_data[:avatarUrl]
    current_user.organization = new_data[:organization] if new_data[:organization]
    current_user.localization = new_data[:localization] if new_data[:localization]
    current_user.lastScan = Time.now

    current_user.save!
  end

  def self.index(user)
    return nil if user.nil?
    raise StandardError, 'Scan was realized less than 5 minutes ago' if user.lastScan && user.lastScan >= 5.minutes.ago

    new_data = ScrappingRepository.process(user.githubUser)
    mutate_data(user, new_data) unless new_data.nil?
  end
end
