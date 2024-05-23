class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :media_files

  validate :media_files_presence

  private

  def media_files_presence
    errors.add(:media_files, 'are required') unless media_files.attached?
  end
end
