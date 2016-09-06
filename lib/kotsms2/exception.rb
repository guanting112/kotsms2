module Kotsms2
  class Error < StandardError; end
  class ClientError < Error; end
  class ServerError < Error; end
  class ClientTimeoutError < Error; end
end