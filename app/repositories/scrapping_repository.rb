require 'open-uri'

class ScrappingRepository
  def self.get_number_with_abbreviation(value)
    multiplier = value[-1]

    if multiplier == 'k'
      return (value.to_f * 1000).to_i
    elsif multiplier == 'm'
      return (value.to_f * 1_000_000).to_i
    end

    value.to_i
  end

  def self.get_number_with_comma(value)
    value.gsub(',', '').to_f.to_i
  end

  def self.process(the_user)
    return nil unless the_user

    doc = Nokogiri::HTML(URI.open("https://github.com/#{the_user}"))

    is_profile = doc.css('.user-profile-sticky-bar').first
    raise StandardError, 'Its not a profile ' if is_profile.nil?

    name = doc.css('span.p-name.vcard-fullname.d-block').text.split(' ').join(' ')
    followers = doc.css('div.js-profile-editable-area .flex-order-1 .mb-3 a')&.first&.css('span')&.text
    following = doc.css('div.js-profile-editable-area .flex-order-1 .mb-3 a')&.last&.css('span')&.text
    stars = doc.css('nav.UnderlineNav-body .UnderlineNav-item.js-responsive-underlinenav-item')&.last&.css('span')&.text
    contributions = doc.css('div.js-yearly-contributions .f4.text-normal.mb-2').first.text.split(' ').first
    avatar_url = doc.css('img.avatar.avatar-user').first.attr('src')
    the_item_prop_first = doc.css('div.js-profile-editable-area .vcard-details .vcard-detail')&.first
    item_prop = the_item_prop_first['itemprop'] if the_item_prop_first
    if item_prop == 'worksFor'
      organization = doc.css('div.js-profile-editable-area .vcard-details .vcard-detail span')&.first&.text
    end
    if item_prop == 'homeLocation'
      localization = doc.css('div.js-profile-editable-area .vcard-details .vcard-detail span')&.first&.text
    end
    if item_prop != 'homeLocation'
      localization = doc.css('div.js-profile-editable-area .vcard-details .vcard-detail span')&.first&.text
    end

    {
      name: name,
      followers: followers ? get_number_with_abbreviation(followers) : nil,
      following: following ? get_number_with_abbreviation(following) : nil,
      stars: stars ? get_number_with_abbreviation(stars) : nil,
      contributions: contributions ? get_number_with_comma(contributions) : nil,
      avatarUrl: avatar_url,
      organization: organization&.strip,
      localization: localization&.strip
    }
  end
end
