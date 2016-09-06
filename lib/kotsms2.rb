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
      @api_host   = options.fetch(:host) { 'api.kotsms.com.tw' }
      @username   = options.fetch(:username) { ENV.fetch('KOTSMS_USERNAME') }
      @password   = options.fetch(:password) { ENV.fetch('KOTSMS_PASSWORD') }
      @timeout    = options.fetch(:timeout) { 10 }
    end

    def account_is_available
      balance_info = get_balance
      balance_info[:message_quota] > 0 && balance_info[:access_success]
    end

    def send_message(options={})
      options[:to] ||= nil
      options[:heavy_loading] ||= false

      options[:content] = options[:content].to_s
      options[:at] = format_time_string(options[:at])
      options[:at] = 0 if options[:at].nil? # 據 Kotsms 文件指出，如果要更即時，可以指定為 0，比不給參數還快

      api_path = '/kotsmsapi-1.php' 
      api_path = '/kotsmsapi-2.php' if options[:heavy_loading]

      response = get(@api_host, api_path, dstaddr: options[:to], smbody: to_big5(options[:content]), dlvtime: options[:at])

      format_send_message_info(response)
    end

    def get_balance
      response = get(@api_host, '/memberpoint.php')

      format_balance_info(response)
    end
  end
end
