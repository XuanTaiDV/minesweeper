# == Schema Information
#
# Table name: mines_boards
#
#  id            :integer          not null, primary key
#  name          :string
#  name_slug     :string
#  email_address :string
#  matrix        :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class MinesBoard < ApplicationRecord
  SLUG_REGEX = /[^a-z0-9]+/

  serialize :matrix, JSON

  validates_presence_of :name, :email_address, :name_slug, :matrix
  validates_uniqueness_of :name
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  before_validation :generate_name_slug

  private

  def generate_name_slug
    return unless attribute_changed?(:name)

    self.name_slug = name.downcase.gsub(SLUG_REGEX, '-').chomp('-')
  end
end
