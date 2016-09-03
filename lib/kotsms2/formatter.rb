module Kotsms2
  module Formatter
    def to_big5(old_string)
      new_string = old_string.encode("BIG5", :invalid => :replace, :undef => :replace, :replace => "?")
    end

    def to_utf8(old_string)
      new_string = old_string.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
    end

    def match_string(rule, string)
      match_data = rule.match(string)
      match_data.nil? ? nil : match_data[1]
    end

    def format_time_string(time)
      return nil if time.nil?
      new_time = to_asia_taipei_timezone(time)
      new_time.strftime('%Y/%m/%d %H:%M:%S')
    end

    def to_asia_taipei_timezone(time)
      utc_time = time.utc? ? time.dup : time.dup.utc
      asia_taipei_time = utc_time.getlocal('+08:00')
      asia_taipei_time
    end

    def format_send_message_info(original_info)
      new_info = {
        access_success: false,
        message_id: nil,
        error: nil
      }

      code_text = match_string(/^kmsgid=(?<code>-?\d+)$/, original_info)
      code_number = code_text.to_i

      new_info[:access_success] = !code_text.nil? && code_number > -1

      if new_info[:access_success]
        new_info[:message_id] = code_number
      else
        new_info[:error] = "KOTSMS:CODE_NOT_FOUND"
        new_info[:error] = "KOTSMS:#{code_text}" unless code_text.nil?
        new_info[:error].upcase!
      end

      new_info
    end

    def format_balance_info(original_info)
      new_info = {
        access_success: false,
        message_quota: 0,
        error: nil
      }

      code_text = match_string(/^(?<code>-?\d+)$/, original_info)
      code_number = code_text.to_i

      new_info[:access_success] = !code_text.nil? && code_number > -1

      if new_info[:access_success]
        new_info[:message_quota] = code_number
      else
        new_info[:error] = "KOTSMS:CODE_NOT_FOUND"
        new_info[:error] = "KOTSMS:#{code_text}" unless code_text.nil?
        new_info[:error].upcase!
      end

      new_info
    end

  end
end