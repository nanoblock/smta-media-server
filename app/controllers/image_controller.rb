class ImageController < ApplicationController
skip_before_filter :verify_authenticity_token, only: [:upload]

  def upload
    bucket_exsist? S3_BUCKET
    begin
      if check_file_params
        S3_BUCKET.put_object(
          body: File.open(params[:file]),
          key: image_bucket + File.basename(params[:file]),
          acl: 'public-read')
        return render status: :ok, json: {"status": "success", "url": s3_path+image_bucket+File.basename(params[:file])}
      end
      
    rescue Exception => e
      s3_upload_fail e
    end
  end

  private
  def s3_path
    return "https://s3.ap-northeast-2.amazonaws.com/showmetheapps/"
  end
  def image_bucket
    return  "media/image/" + @token["user_id"] + "/"
  end

  def check_file_params
    if params[:file]
      return true
    else
      return false
    end
  end

end