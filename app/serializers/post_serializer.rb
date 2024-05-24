class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :created_at, :updated_at
  has_many :media_files

  def media_files
    object.media_files.map do |file|
      {
        id: file.id,
        filename: file.filename.to_s,
        content_type: file.content_type,
        url: Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)
      }
    end
  end
end

