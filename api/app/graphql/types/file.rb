module Types
  # Custom Scalar Type for File Uploads
  class File < GraphQL::Schema::Scalar
    description "action_dispatch_uploaded_file"
    def self.coerce_input(file, _ctx)
      return nil if file.nil?

      ActionDispatch::Http::UploadedFile.new(
        filename: file.original_filename,
        type: file.content_type,
        head: file.headers,
        tempfile: file.tempfile
      )
    end
  end
end
