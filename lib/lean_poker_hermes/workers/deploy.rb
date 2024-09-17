require "sidekiq"
require "faraday"
require_relative "../../hash_ext"

class LeanPokerHermes::Workers::Deploy
  include Sidekiq::Job

  def perform(id, owner, repository, archive_url, commit, message, callback_url, target_heroku_api_key, deploy_id = nil)
    deploy = if deploy_id.nil?
      LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deploy(id, archive_url, commit)
    else
      LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deployment_info(id, deploy_id)
    end

    if deploy["status"] == "pending"
      # Reschedule job in 15 seconds
      LeanPokerHermes::Workers::Deploy.perform_at(Time.now + 15, id, owner, repository, archive_url, commit, message, callback_url, target_heroku_api_key, deploy["id"])
    else
      success = (deploy["status"] == "succeeded") ? "1" : "0"

      logs = Faraday.get(deploy["output_stream_url"]).body.force_encoding("ISO-8859-1")

      p callback_url
      p id
      p owner
      p repository
      p commit
      p message
      p success
      p logs

      info = {
        "id" => id,
        "owner" => owner,
        "repository" => repository,
        "commit" => commit,
        "message" => message,
        "success" => success,
        "logs" => logs
      }

      LeanPokerHermes::Workers::RespondToCallback.perform_async(callback_url, info.stringify_keys)
    end
  rescue Excon::Error::Forbidden
    info = {
      "id" => id,
      "owner" => owner,
      "repository" => repository,
      "commit" => commit,
      "message" => message,
      "success" => "0",
      "logs" => logs
    }

    LeanPokerHermes::Workers::RespondToCallback.perform_async(callback_url, info.stringify_keys)
  end
end
