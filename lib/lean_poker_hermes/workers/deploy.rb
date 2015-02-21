require 'sidekiq'

class LeanPokerHermes::Workers::Deploy
  include Sidekiq::Worker

  def perform(id, owner, repository, commit, callback_url)
    deploy = LeanPokerHermes::HerokuGateway.instance.deploy(id, owner, repository, commit)

    begin
      info = LeanPokerHermes::HerokuGateway.instance.deployment_result(id,deploy['id'])
    end while info['build']['status'] == 'pending'

    success = (info['build']['status'] == 'succeeded')
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