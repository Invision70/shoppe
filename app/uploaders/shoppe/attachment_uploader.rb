# encoding: utf-8

class Shoppe::AttachmentUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick


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
    process :convert => 'jpg'
    process :resize_and_pad => [200, 200]
  end

  version :preview, :if => :image? do
    process :convert => 'jpg'
    process :resize_and_pad => [540, 720]
  end
  version :preview_limit, :if => :image? do
    process :convert => 'jpg'
    process :resize_to_limit => [540, 720]
  end

  version :big, :if => :image? do
    process :convert => 'jpg'
    # process :resize_to_limit => [900, 900]
  end

end