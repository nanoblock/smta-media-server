class AwsLib
  # :bucket => ENV['AMAZON_S3_BUCKET_NAME'],
#     :s3_region => ENV['AMAZON_S3_REGION'],
#     :s3_host_name => ENV['AMAZON_S3_HOST_NAME'],
#     :s3_credentials => {
#       :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
#       :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
#   }

  BUCKET = ENV['AMAZON_S3_BUCKET_NAME'].freeze

  def initialize file
    @file = file
    @s3 = AWS::S3.new
    @bucket = @s3.buckets[BUCKET]
  end

  def store
    @file = file
    @s3 = AWS::S3.new
    @bucket = @s3.buckets[BUCKET]
    @obj = @bucket.objects[filename].write(@file.tempfile, acl: :public_read)
    self
  end

  def url
    @obj.public_url.to_s
  end

  private
  
  def filename
    @filename ||= @file.original_filename.gsub(/[^a-zA-Z0-9_\.]/, '_')
  end
end