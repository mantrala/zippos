class PerformSearch
  def self.run(zip, current_user, country='us')
    country = country || 'us'
    zippo = Zippo.where('zipcode = ? and country_abbr = ?', zip, country.upcase).first

    if zippo.blank?
      zippopotamus = Zippopotamus.new zip, country
      return zippopotamus.run
    else
      response = {}
      user_has_zip = zippo.users.any? { |user| user == current_user }
      if user_has_zip
        response[:exists] = true 
        return response
      end

      response[:zippo] = zippo
      return response
    end
  end

end