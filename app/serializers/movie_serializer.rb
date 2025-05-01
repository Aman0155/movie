class MovieSerializer < ActiveModel::Serializer
attributes :id, :title, :genre, :release_year, :rating, :duration, :description, :premium, :poster_url

#   def poster_url
#     if object.poster.attached?
#       object.poster.service.url(object.poster.key, eager: true) 
#     else
#       nil
#     end
#   end
# end
def poster_url
  if object.poster.attached?
    begin
      object.poster.service.url(
        object.poster.key,
        eager: true,
        expires_in: 1.hour,          # URL kitni der tak valid rahega
        filename: object.poster.filename,
        content_type: object.poster.content_type,
        disposition: 'inline'        # File browser mein dikhega, download nahi hoga
      )
    rescue StandardError => e
      Rails.logger.error("Failed to generate poster URL: #{e.message}")
      nil
    end
  else
    nil
  end
end
end 