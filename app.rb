require 'sinatra/base'
require 'pony'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require 'dcm2nii-ruby'
require 'fsl-ruby'
require 'narray'
require 'nifti'
require 'chunky_png'
require 'prawn'
require 'zip'

require_relative 'lib/workers/change_folder.rb'
Rack::Utils.multipart_part_limit = 0

class HelloWorldApp < Sinatra::Base

 
get "/upload" do
  erb :upload
end 

post "/upload" do

  now = Time.now.to_i.to_s
  path = "uploads/" + now + params['myfile'][:filename]
  zipfolder = "/dicom/zip/"
  unzipfolder = "/dicom/unzip/"
  filename = params['myfile'][:tempfile].read
  name = now + params['myfile'][:filename]

  File.open(path, "w") do |f|
    f.write(filename)
  end
  
  ChangeFolder.perform_async(path, zipfolder, name, unzipfolder, now)
  #Pony.mail({
  #  :to => 'catalinabustam@gmail.com',
  #  :subject => "prueba imagen",
  #  :body => "prueba",
  #  :via => :smtp,
  #  :attachments => {File.basename("uploads/#{params['myfile'][:filename]}") => File.read("uploads/#{params['myfile'][:filename]}")},
  #  :via_options => {
  #   :address              => 'smtp.gmail.com',
  #   :port                 => '587',
  #   :enable_starttls_auto => true,
  #   :user_name            => 'alertasiatm@gmail.com',
  #   :password             => 'AlertasIatm2015',
  #   :authentication       => :plain, 
  #   :domain               => "localhost.localdomain"
  #       }
  #      })
  return "uploads/#{params['myfile'][:filename]}"
  return
end

end
