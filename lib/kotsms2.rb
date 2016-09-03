require 'kotsms2/version'
require 'kotsms2/network'
require 'kotsms2/exception'
require 'kotsms2/formatter'

module Kotsms2
  class Client
    include Kotsms2::Network
    include Kotsms2::Formatter

    def initialize(options={})
      @user_agent = options.fetch(:agent) { "kotsms2/#{VERSION}" }
      @api_host   = options.fetch(:host) { 'api.twsms.com' }
      @username   = options.fetch(:username) { ENV.fetch('TWSMS_USERNAME') }
      @password   = options.fetch(:password) { ENV.fetch('TWSMS_PASSWORD') }
    end

    def account_is_available
      balance_info = get_balance

      ok = balance_info[:message_quota] > 0 && balance_info[:access_success]
    end

    def send_message(options={})
      options[:to]      ||= nil
      options[:content] ||= nil
      options[:at]      = format_time_string(options[:at])
      options[:long]    = options[:long] || options[:long].nil? ? :Y : :N
      options[:popup]   = options[:popup] ? :Y : :N

      response = get(@api_host, '/smsSend.php', popup: options[:popup], mo: :N, longsms: options[:long], mobile: options[:to], message: options[:content], drurl: '', sendtime: options[:at])

      format_send_message_info(response)
    end

    def get_balance
      response = get(@api_host, '/smsQuery.php', deltime: :N, checkpoint: :Y, mobile: '', msgid: '')

      format_balance_info(response)
    end
  end
end
