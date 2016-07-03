require 'sidekiq'

class LeanPokerHermes::Workers::Deploy
  include Sidekiq::Worker

  def perform(id, owner, repository, archive_url, commit, callback_url, target_heroku_api_key)
    deploy = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deploy(id, archive_url, commit)

    begin
      info = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).deployment_result(id,deploy['id'])
      sleep 15
    end while info['build']['status'] == 'pending'

    success = (info['build']['status'] == 'succeeded') ? '1' : '0'
    logs = info['lines'].map { |line| line['line'] }.join('')

    info = {
        :id => id,
        :owner => owner,
        :repository => repository,
        :commit => commit,
        :success => success,
        :logs => logs
    }

    HttpRequestLight.post(callback_url, info, 30) do |error, _|
      if error
        raise Exception.new("Failed to respond through callback url")
      end
    end
  end
end