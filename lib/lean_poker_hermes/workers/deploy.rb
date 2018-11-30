require 'sidekiq'
require 'faraday'

class LeanPokerHermes::Workers::Deploy
  include Sidekiq::Worker

  def perform(id, owner, repository, archive_url, commit, callback_url, target_heroku_api_key)
    deploy = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deploy(id, archive_url, commit)

    #begin
    #  sleep 15
    #  info = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deployment_result(id,deploy['id'])
    #end while info['build']['status'] == 'pending'

    #success = (info['build']['status'] == 'succeeded') ? '1' : '0'
    #logs = info['lines'].map { |line| line['line'] }.join('')

    #info = {
    #    :id => id,
    #    :owner => owner,
    #    :repository => repository,
    #    :commit => commit,
    #    :success => success,
    #    :logs => logs
    #}

    #LeanPokerHermes::Workers::RespondToCallback.perform_async(callback_url, info)
  end
end
