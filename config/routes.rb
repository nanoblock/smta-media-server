Rails.application.routes.draw do
  post 'api/media/token/validation' => 'application#validation'

  post '/api/media/image/upload' => 'image#upload'
  post '/api/media/video/upload' => 'video#upload'
end
