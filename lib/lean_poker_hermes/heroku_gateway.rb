
class LeanPokerHermes::HerokuGateway
  def initialize(target_heroku_api_key)
    @platform_api = PlatformAPI.connect_oauth(target_heroku_api_key)
  end

  def create
    @platform_api.app.create({})
  end

  def list
    @platform_api.app.list
  end

  def delete(name)
    @platform_api.app.delete(name)
  end

  def deploy(name, archive_url, commit)
    options = {
        "source_blob" => {
            "url" => archive_url,
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

  def self.instance(target_heroku_api_key = nil)
    api_key = target_heroku_api_key || ENV['TARGET_HEROKU_API_KEY']

    if @instance.nil?
      @instance = {}
    end

    @instance[api_key] ||= new(api_key)
  end
end