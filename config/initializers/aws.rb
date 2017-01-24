region = ENV['AMAZON_S3_REGION'].freeze
key = ENV['AMAZON_ACCESS_KEY_ID'].freeze
access_key = ENV['AMAZON_SECRET_ACCESS_KEY'].freeze
bucket_name = ENV['AMAZON_S3_BUCKET_NAME'].freeze

Aws.config.update({
  region: region,
  credentials: Aws::Credentials.new(key, access_key)
})

# :bucket => ENV['AMAZON_S3_BUCKET_NAME'],
#     :s3_region => ENV['AMAZON_S3_REGION'],
#     :s3_host_name => ENV['AMAZON_S3_HOST_NAME'],
#     :s3_credentials => {
#       :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
#       :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
#   }

#   @file = params[:file]
    # @s3 = AWS::S3.new
    # @bucket = @s3.buckets[ENV['AMAZON_S3_BUCKET_NAME'].freeze]
    # @obj = @bucket.objects[filename].write(@file.tempfile, acl: :public_read)
      # image = AwsLib.new(params[:file]).store

S3_BUCKET = Aws::S3::Resource.new.bucket(bucket_name)

# S3_BUCKET.put_object(
#           body: file_open,
#           key: "media/image/#{file_name}",
#           acl: 'public-read'
#       )