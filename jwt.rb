require 'jwt'
require 'net/http'
require 'time'


keyFile = File.read('./AuthKey_XXXX.p8') # replace to your .p8 private key file (donwload from app stroe connect)
privateKey = OpenSSL::PKey::EC.new(keyFile)

payload = {
            iss: 'YOUR_ISSUE_ID', # replace to your issue id (get in app store connect user access->key->app store connect api page)
            iat: Time.now.to_i,
            exp: Time.now.to_i + 60*20,
            aud: 'appstoreconnect-v1'
          }

token = JWT.encode payload, privateKey, 'ES256', header_fields={kid:"YOUR_KEY_ID", typ:"JWT"} # replace to your key id (get in app store connect user access->key->app store connect api page)
puts token

decoded_token = JWT.decode token, privateKey, true, { algorithm: 'ES256' }
puts decoded_token


uri = URI("https://api.appstoreconnect.apple.com/v1/apps/APPID/customerReviews") # repleace APPID to your app id in app store connect -> your app -> app information -> apple id
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true

request = Net::HTTP::Get.new(uri)
request['Authorization'] = "Bearer #{token}";

response = https.request(request)
puts response.read_body