class VideoController < ApplicationController
skip_before_filter :verify_authenticity_token, only: [:upload]

  def upload
    bucket_exsist? S3_BUCKET
    begin
      if check_file_params
        S3_BUCKET.put_object(
          body: File.open(params[:file]),
          key: video_bucket + File.basename(params[:file]),
          acl: 'public-read')
      end
      render status: :ok, json: {"body": request.body}
    rescue Exception => e
      s3_upload_fail e
    end
  end

  private

  def video_bucket
    return  "media/video/" + @token["user_id"] + "/"
  end

  def check_file_params
    if params[:file]
      return true
    else
      return false
    end
  end

end
