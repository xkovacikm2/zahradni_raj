class FileUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  process :save_file_attributes
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    return unless original_filename

    extension = File.extname(original_filename)
    name = File.basena(original_filename, extension)

    "#{Time.current.to_i.to_s}-#{name.parametrize}#{extension}"
  end

  def save_file_attributes
    return unless file && model

    model.size = file.size

    original_filename = file.respond_to?(:original_filename) ? file.original_filename : nil

    return unless original_filename

    model.extension = File.extname(original_filename)
    model.name = File.basename(original_filename, model.extension)
  end
end
