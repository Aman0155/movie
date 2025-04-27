class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :release_year, :rating, :duration, :description, :premium, :poster_url

  def poster_url
    if object.poster.attached?
      object.poster.service.url(object.poster.key, eager: true) 
    else
      nil
    end
  end
end
