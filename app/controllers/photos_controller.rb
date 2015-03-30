def check_photo_processing
  @photo_status = Photo.find(params[:photo_id]).attachment_is_processing

  respond_to do |wants|
    wants.js
  end
end
