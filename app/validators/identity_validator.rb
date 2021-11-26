class IdentityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value == record.followed_id

    record.errors.add attribute, (options[:message] || "followed and follower cannot be the same user")
  end
end
