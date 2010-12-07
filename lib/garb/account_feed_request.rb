module Garb
  class AccountFeedRequest
    URL = "https://www.google.com/analytics/feeds/accounts/default"

    def initialize(session = Session)
      @request = DataRequest.new(session, URL)
    end

    def response
      @response ||= @request.send_request
    end

    def parsed_response
      @parsed_response ||= XmlSimple.xml_in(response.body, { 'ForceArray' => ['entry'] })
    end

    def entries
      parsed_response ? [parsed_response['entry']].flatten : []
    end

    def segments
      parsed_response ? [parsed_response['dxp:segment']].flatten : []
    end
  end
end
