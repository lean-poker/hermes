require 'sidekiq'
require 'faraday'

class LeanPokerHermes::Workers::Deploy
  include Sidekiq::Worker

  def perform(id, owner, repository, archive_url, commit, callback_url, target_heroku_api_key)
    deploy = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deploy(id, archive_url, commit)

    begin
      sleep 15
      info = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deployment_info(id,deploy['id'])
    end while info['status'] == 'pending'

    success = (info['status'] == 'succeeded') ? '1' : '0'

    logs = Faraday.get(deploy['output_stream_url']).body

    info = {
       :id => id,
       :owner => owner,
       :repository => repository,
       :commit => commit,
       :success => success,
       :logs => logs
    }

    LeanPokerHermes::Workers::RespondToCallback.perform_async(callback_url, info)
  end
end
