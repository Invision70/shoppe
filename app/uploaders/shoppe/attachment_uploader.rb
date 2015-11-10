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
    process :uploader_resize_and_pad => [200, 200]
  end

  version :preview, :if => :image? do
    process :convert => 'jpg'
    process :uploader_resize_and_pad => [540, 720]
  end

  version :big, :if => :image? do
    process :convert => 'jpg'
    process :uploader_resize_to_fit => [900, 900]
  end

  def uploader_resize_and_pad(width, height, background=:transparent, gravity=::Magick::CenterGravity)
    manipulate! do |img|
      if img.columns >= width
        img.resize_to_fit!(width, height)
        new_img = ::Magick::Image.new(width, height) { self.background_color = background == :transparent ? 'rgba(255,255,255,0)' : background.to_s }
        if background == :transparent
          filled = new_img.matte_floodfill(1, 1)
        else
          filled = new_img.color_floodfill(1, 1, ::Magick::Pixel.from_color(background))
        end
        destroy_image(new_img)
        filled.composite!(img, gravity, ::Magick::OverCompositeOp)
        destroy_image(img)
        filled = yield(filled) if block_given?
        filled
      else
        img = yield(img) if block_given?
        img
      end
    end
  end

  def uploader_resize_to_fit(width, height)
    manipulate! do |img|
      if img.columns >= width
        img.resize_to_fit!(width, height)
      end
      img = yield(img) if block_given?
      img
    end
  end

end