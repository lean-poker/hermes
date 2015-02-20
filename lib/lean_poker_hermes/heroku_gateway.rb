
class LeanPokerHermes::HerokuGateway
  def initialize
    @platform_api = PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
  end

  def create(name = nil)
    options = name.nil? ? {} : {'name' => name}
    @platform_api.app.create(options)
  end

  def delete(name)
    @platform_api.app.delete(name)
  end

  def deploy(name, repository, commit)
    options = {
        "source_blob" => {
            "url" => "https://github.com/#{repository}/archive/#{commit}.tar.gz",
            "version" => commit
        }
    }
    @platform_api.build.create(name, options)
  end

  def self.instance
    @instance ||= new
  end
end