require 'aws-sdk-s3'
require 'json'

def handler(event, context:)
    puts events
    s3 = Aws::S3::Resource.new
    bucket_name= ENV["UPLOADS_BUCKET_NAME"]
    object_key = 'mock.jpg'

    obj = s3.bucket(bucket_name).object(object_key)
    url = obj.presigned_url(:put, expires_in: 3600)
    url #This data will be returned
    result = { url: url}.to_json 
    { statusCode: 200, body: result }
end