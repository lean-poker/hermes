
class LeanPokerHermes::HerokuGateway
  def initialize
    @platform_api = PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
  end

  def create
    @platform_api.app.create({})
  end

  def add_log_drain(name, url)
    @platform_api.log_drain.create(name, { "url" => url })
  end

  def delete(name)
    @platform_api.app.delete(name)
  end

  def deploy(name, owner, repository, commit)
    options = {
        "source_blob" => {
            "url" => "https://github.com/#{owner}/#{repository}/archive/#{commit}.tar.gz",
            "version" => commit
        }
    }
    @platform_api.build.create(name, options)
  end

  def deployment_info(app_name, deploy_id)
    @platform_api.build.info(app_name, deploy_id)
  end

  def deployment_result(app_name, deploy_id)
    @platform_api.build_result.info(app_name, deploy_id)
  end

  def self.instance
    @instance ||= new
  end
end