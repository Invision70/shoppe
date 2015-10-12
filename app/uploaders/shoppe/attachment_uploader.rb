# encoding: utf-8

class Shoppe::AttachmentUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick


  # Where should files be stored?
  def store_dir
    "attachment/#{model.id}"
  end

  # Returns true if the file is an image
  def image?(new_file)
    self.file.content_type.include? 'image'
  end

  # Returns true if the file is not an image
  def not_image?(new_file)
    !self.file.content_type.include? 'image'
  end

  # Create different versions of your uploaded files:
  version :thumb, :if => :image? do
    process :convert => 'png'
    process :resize_and_pad => [200, 200]
  end

  version :preview, :if => :image? do
    process :resize_to_fill => [540, 720]
  end

  version :big, :if => :image? do
    process :resize_to_fit => [900, 900]
  end

end