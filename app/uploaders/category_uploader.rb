# encoding: utf-8

class CategoryUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  version :small do
    process :resize_to_fill => [100,100]
  end

  version :normal do
    process :resize_to_fill => [250,250]
  end
end
