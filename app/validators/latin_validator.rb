class LatinValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value =~ /^[\x00-\x7F]+$/
      record.errors[attribute] << (options[:message] || 'only latin letters and non alphanumeric characters are allowed') unless value.blank?
    end
  end

end