require 'httmultiparty'

module API
  # API paths to send requests to
  API_PATHS = {
    files: '/files'
  }

  class HTTP
    include HTTMultiParty

    def self.setup(config)
      @config = config
      base_uri config['server']
      @auth = {:username => config['email'], :password => config['pass']}
    end

    def self.post_file(path, replace)
      res = self.post(API_PATHS[:files], :query => {
        :file => {
          :file => File.open(path)
        },
        :from => 'pack-client',
        :replace => replace == true ? 'true' : nil
      }, :detect_mime_type => true,
         :accept => :json,
         :basic_auth => @auth)

      puts res.code == 200 ? 'Done.' : 'Error! ' + res.message
      puts res
    end

    def self.delete_file(path)
      url = API_PATHS[:files] + '/' + @config['username'] + '/' + File.basename(path)
      puts url
      res = self.delete(url, :accept => :json, :basic_auth => @auth)
      puts res.code == 200 ? 'Deleted': 'Error! ' + res.message
    end
  end
end
