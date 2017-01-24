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
        return render status: :ok, json: {"status": "success", "url": s3_path+video_bucket+File.basename(params[:file])}
      end

      @incoming_file = params[:video]
      @file_name = params[:video].original_filename

      FileUtils.mv @incoming_file.tempfile, path(@file_name)

      S3_BUCKET.put_object(
          body: File.open(path(@file_name)),
          key: video_bucket + @file_name,
          acl: 'public-read')
      
      File.delete(path(@file_name)) if File.exist?(path(@file_name))
    rescue Exception => e
      s3_upload_fail e
    end
    
    http_post(@token["token"], s3_path+video_bucket+@file_name)
  end

  private
  def s3_path
    return "https://s3.ap-northeast-2.amazonaws.com/showmetheapps/"
  end

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

  def log_path
    return Rails.root.join('log', 'request.txt')
  end

  def path(url)
    return Rails.root.join('log', url)
  end

  def http_host
    return 'showmetheapps.co'
  end

  def http_path
    return "/api/videos"
  end

  def http_post(access_token, url)
    req = Net::HTTP::Post.new(http_path)
    req.set_form_data({'access_token' => access_token, 
      'project[name]' => "쇼미 앱", 
      'project[desc]' => "설명을 수정해 주세요.",
      'video[url]' => url})

    res = Net::HTTP.new(http_host).start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      render status: :ok, json: {"status": "success", "url": s3_path+video_bucket+@file_name}
    else
      render status: 304, json: {"status": "error", "message": "Network Error"}
    end
  end

end
