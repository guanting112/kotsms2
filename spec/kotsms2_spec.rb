require 'minitest/autorun'
# require 'webmock/minitest'
require 'kotsms2'
require 'json'

describe 'Kotsms2::Client' do
  before do
    @fake_username = 'KotSMS 2 API 自動化單元測試'
    @fake_password = Time.now.to_i

    @sms_client = Kotsms2::Client.new(username: @fake_username, password: @fake_password)
  end

  describe '測試 message_status_sanitize 方法' do
    it '必須通過以下一連串的測試，全部通過須為 true' do

      default_status = true
      result = default_status
      undefined_status = "#{Time.now}"

      test_data_collection = [
        { original_status: 'DELIVRD', it_should_be: 'delivered' },
        { original_status: 'EXPIRED', it_should_be: 'expired' },
        { original_status: 'DELETED', it_should_be: 'deleted' },
        { original_status: 'UNDELIV', it_should_be: 'undelivered' },
        { original_status: 'ACCEPTD', it_should_be: 'transmitting' },
        { original_status: 'UNKNOWN', it_should_be: 'unknown' },
        { original_status: 'REJECTD', it_should_be: 'rejected' },
        { original_status: 'SYNTAXE', it_should_be: 'incorrect_sms_system_syntax' },
        { original_status: undefined_status, it_should_be: 'status_undefined' }
      ]

      test_data_collection.each do |test_data|
        incorrect = @sms_client.message_status_sanitize(test_data[:original_status]) != test_data[:it_should_be]

        if incorrect
          result = false
          break
        end
      end

      result.must_equal(true)
    end
  end

  describe '測試 Kotsms2::ClientTimeoutError ' do
    it '刻意將 timeout 設定為 0，看是否可以 rescue 到' do
      rescue_timeout_exception = false

      begin
        sms_client = Kotsms2::Client.new(username: @fake_username, password: @fake_password, timeout: 0)
        sms_client.account_is_available
      rescue Kotsms2::ClientTimeoutError
        rescue_timeout_exception = true
      end

      rescue_timeout_exception.must_equal(true)
    end
  end

  describe '確認字串編碼與轉換' do
    it '預設 Ruby 環境的字串，必須要是 UTF-8' do
      "簡訊測試 #{Time.now}".encoding.to_s.must_equal('UTF-8')
    end

    it '必須要是 UTF-8' do
      sample_article = '住時教注特再大會學？件知近望治，北車也看動，認辦起任工輪大可我世從！行兒而旅到年不食過寫告病白生由！生我上不馬備的人富上修是我野女如名、子運間面麼，們校之大政告直告而斯心音師保現？破家物！理不我自她裡解發油因：又數會度作、總經當健活師爭話羅積不頭道就甚天……響極人笑的品的為在老市終低別地重義……遠己種還應學環坐時星自前家度後能使了德看用不個起她身果新兒分水教門我所心坡設。布為廣單一英飯門得離效天對節家！白玩人最數旅十？研臺係兩取？已皮候你物：務海不第心多；程我德兒此廣。可登大家，動再他。中度的於示應看相是地前見會跟分年一；大麼展差，特文知設年的構空成那工時，問此子試品正與難一便的子記力站強人消開而統稱感紅見不創舉媽話好手度案容形度第方電者，不母式戰要師的星詩媽引分低有無陸清們可區水！事香當器，農吸內望出報老求因、性名所到面世個角投她系分們沒，來我再？人量內生整成全對？委於中我受、身性如寫夜因一上樂發到員是不：紙了部氣交電懷上灣度長小是是我他士根冷，上病球羅用語光這等那選這高率作下會的她、我官面放想指竟，產東是的。以面美溫日調新要司開。樂管電論來列見，多我經人？線地所全：雜他做現則能謝。不室本個快死？我土手，後何自望進成管燈……正後飛學高的……安苦木有運難產學沒高看室目立線門體光算為筆過法要了是際取來。文孩時人單到金車立公只要的，推必識長沒雲解會。報雖們。腦質了一理陽與其切益發角師美把象神往的離的前前！石想好輕隊快思空時意精……座連看他眼們又舉！和益以什在來致下們日小說；實書因像而走十持麼香形著我急物年嚴縣盡解，三的理位眾。明觀劇收保媽！兒廣向林要和法，謝車書行數友學是走軍家，新且兒錯果，長會應路養，他立著理心有樣人行一之的由！了面驗腦大藥不動是上務地民又動著感轉己轉呢難將初情兒成內以時有一下部經飯這作樂電不。可麼格白相活本及太為時須光指構種為本里名音洲是少太坡很麼升者！火場西不房念事身通們例，他改任眼？合況不什代這對感座，正國制心委學力：向我聞子不銷子手國。團非開親到工反己友多教不以老人任工的指重放光失我女的；定維。新利朋作，人術直面。表麼發應，以個和體前所，思皮化腦找力壓辦升開結兩新初著坡斷一半然新所傳個假子定子表，你阿為同劇一；日資神不我眼也女當合工，本外開石了不有後。成被他，牛頭地不縣不園清就益新滿邊取吃力達速發輕元事大倒明雄林樂少過團。一張制保做演灣山錯又。來達們學當金樣。化子應分大命，傳會一出要，知是河為人解喜，爸農如跟令始今李風是文民解和親她當北覺化。師長去此，他人越名看求修第河目在在般期大就教、明留之，樣片書眼這勢；企引的角？時影不原現？現廠直樹得不林友、講立陽仍！高位己們小下一的自利眾出衣景……一慢主國字德格天一全千源己整林洋！'

      big5_text = @sms_client.to_big5(sample_article)
      utf8_text = @sms_client.to_utf8(big5_text)
      utf8_text.must_equal(sample_article)
    end
  end

  describe '測試 client 的用的 轉換 time zone 方法' do
    it '應該會是 +8:00 的時區' do
      custom_time_with_leap_year   = Time.new(2008, 2, 29, 1, 2, 3, '+12:00')
      custom_time_2_with_leap_year = Time.new(2008, 2, 29, 10, 20, 30, '+12:00')
      new_time = @sms_client.to_asia_taipei_timezone(custom_time_with_leap_year)

      result = custom_time_with_leap_year == new_time && 
               custom_time_2_with_leap_year != new_time && 
               new_time.strftime('%z') == '+0800'

      result.must_equal(true)
    end
  end

  describe '當 client 建立時，有指定 agent 參數，get 方法裡的 user-agent 是否會改變 ' do
    it '應該會變成使用者自訂的 user-agent 字串 ( 以 httpbin.org/get 為準 )' do
      custom_user_agnet = "agent: #{Time.now.to_i}"
      sms_client = Kotsms2::Client.new(username: @fake_username, password: @fake_password, agent: custom_user_agnet)
      response = JSON.parse(sms_client.get('httpbin.org', '/get'))
      response['headers']['User-Agent'].must_equal(custom_user_agnet)
    end
  end

  describe '以不存在的帳號密碼，使用 send_message 方法' do
    it '必須回傳錯誤的結果，ERROR 的部分需要為 KOTSMS:-2' do
      @sms_client.send_message(content: 'kotsms2 單元測試').must_equal({:access_success=>false, :message_id=>nil, :error=>"KOTSMS:-2"})
    end
  end

  describe '以不存在的帳號密碼，使用 get_balance 方法' do
    it '必須回傳錯誤的結果，ERROR 的部分需要為 KOTSMS:-2' do
      @sms_client.get_balance.must_equal({:access_success=>false, :message_quota=>0, :error=>"KOTSMS:-2"})
    end
  end

  describe '以不存在的帳號密碼，使用 get_message_status 方法' do
    it '必須回傳錯誤的結果，ERROR 的部分需要為 KOTSMS:MEMBERERROR' do
      # Kotsms 的 狀態回傳 實作上，沒有完全按照文件
      @sms_client.get_message_status(message_id: '1234').must_equal({:access_success=>false, :is_delivered=>false, :message_status=>"status_undefined", :error=>"KOTSMS:MEMBERERROR"})
    end
  end
end