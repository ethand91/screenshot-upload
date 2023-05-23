class Api::ImagesController < ApplicationController
  def save_image
    begin
      data = params[:image].sub("data:image/png;base64", "")
      image_data = Base64.decode64(data)
      image_io = StringIO.new(image_data)
      image_io.class.class_eval { attr_accessor :original_filename, :content_type }
      image_io.original_filename = "image.png"
      image_io.content_type = "image/png"

      @image = Image.new
      @image.image.attach(io: image_io, filename: "image.png", content_type: "image/png")

      if @image.save
        render json: { message: "Image saved successfully" }, status: :ok
      else
        render json: { error: @image.errors.full_message }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "An error occurred whilst saving the image" }, status: :internal_server_error
    end
  end
end
