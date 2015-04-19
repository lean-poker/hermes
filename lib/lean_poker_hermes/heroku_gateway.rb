
class LeanPokerHermes::HerokuGateway
  def initialize
    @platform_api = PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
  end

  def create
    @platform_api.app.create({})
  end

  def list
    @platform_api.app.list
  end

  def set_buildpack(app_name, buildpack)
    self.set_config_vars app_name, { "BUILDPACK_URL" => buildpack }
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

  def add_log_drain(name, url)
    p "Adding logdrain #{url} to #{name}"
    drain = @platform_api.log_drain.create(name, { "url" => url })
    drain['id']
  end

  def delete_log_drain(name, drain_id)
    p "Deleting logdrain #{drain_id} from #{name}"
    @platform_api.log_drain.delete(name, drain_id)
  end

  def get_config_vars(name)
    @platform_api.config_var.info(name)
  end

  def set_config_vars(name, config_vars)
    @platform_api.config_var.update(name, config_vars)
  end

  def self.instance
    @instance ||= new
  end
end