ActiveAdmin.register Movie do
  permit_params :title, :genre, :release_year, :director, :duration, :description, :premium, :poster

  index do
    selectable_column
    id_column
    column :title
    column :genre
    column :release_year
    column :duration
    column :description
    column :premium
    column :poster do |movie|
      if movie.poster.attached?
        image_tag cl_image_path(movie.poster.key, width: 100, crop: :fill), alt: "Poster"
      else
        "No Poster"
      end
    end
    column :poster_url do |movie|
      movie.poster.attached? ? cloudinary_url(movie.poster.key) : "N/A"
    end
    actions
  end

  filter :title
  filter :genre
  filter :release_year
  filter :duration
  filter :premium

  form do |f|
    f.inputs do
      f.input :title
      f.input :genre
      f.input :release_year
      f.input :duration
      f.input :description
      f.input :premium
      f.input :poster, as: :file
    end
    f.actions
  end
end