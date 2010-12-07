module Garb
  class Report
    include Resource

    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    def initialize(profile, opts={})
      ActiveSupport::Deprecation.warn("The use of Report will be removed in favor of 'extend Garb::Model'")

      @profile = profile

      @start_date = opts.fetch(:start_date, Time.now - MONTH)
      @end_date = opts.fetch(:end_date, Time.now)
      @limit = opts.fetch(:limit, nil)
      @offset = opts.fetch(:offset, nil)

      @response = nil
      
      metrics opts.fetch(:metrics, [])
      dimensions opts.fetch(:dimensions, [])
      aggregate opts.fetch(:aggregate, [])
      sort opts.fetch(:sort, [])
    end

    def results
      if @response
        @response.results
      else
        body = @debug = send_request_for_body
      
        @response = ReportResponse.new(body)
        @response.results
      end
    end
    
    def more_info
      if @response
        @response.more_info
      else
        results
        @response.more_info
      end
    end
  end
end
