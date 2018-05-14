module UsersHelper
  def gravatar_for(user, size: 80)
    gravator_id = Digest::MD5::hexdigest(user.email.downcase)
    gravator_url = "https://secure.gravator.com/avatar/#{gravator_id}?s=#{size}"
    image_tag(gravator_url, alt: user.name, class: "gravator")
  end
end
