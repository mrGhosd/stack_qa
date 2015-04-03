# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def default_url
    "/images/empty-user.png"
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end
end
