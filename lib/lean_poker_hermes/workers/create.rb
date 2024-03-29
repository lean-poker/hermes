require "sidekiq"
require "debug"

class LeanPokerHermes::Workers::Create
  include Sidekiq::Job

  def perform(callback_url, buildpack = nil, environment_variables = nil, target_heroku_api_key = nil)
    app = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).create

    app_info = {
      "id" => app["id"],
      "name" => app["name"],
      "url" => app["web_url"]
    }

    environment_variables = build_environment_variables(app_info, buildpack, environment_variables)
    LeanPokerHermes::Workers::SetupEnvironmentVariables.perform_async(callback_url, app_info, environment_variables, target_heroku_api_key)
  end

  private

  def build_environment_variables(app_info, buildpack, environment_variables)
    environment_variables ||= {}
    unless buildpack.nil?
      environment_variables["BUILDPACK_URL"] = buildpack
    end
    environment_variables["HOST"] = app_info[:url]
    environment_variables
  end
end
