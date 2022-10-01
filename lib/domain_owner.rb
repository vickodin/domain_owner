require 'domain_owner/version'
require 'net/http'
require 'json'

module DomainOwner
  API_URL = 'https://owner.platform.monster/api/domains'

  class Error < StandardError; end
  class WrongParams < Error; end
  class ServerError < Error; end

  class << self
    def request(domain:, owner_id:, key:)
      body = ask(domain: domain, owner_id: owner_id, key: key)
      JSON.parse(body)
    end

    private

    def ask(form)
      uri = URI(API_URL)
      res = ::Net::HTTP.post_form(URI(API_URL), form)
      return res.body if res.is_a?(Net::HTTPOK)

      # 404:
      raise WrongParams.new('Check params') if res.is_a?(Net::HTTPNotFound)
      raise ServerError.new('Something weng wrong') if res.is_a?(Net::HTTPServerError)

      res.body
    end
  end
end
