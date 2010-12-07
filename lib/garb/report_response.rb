module Garb  
  class ReportResponse
    KEYS = ['metric', 'dimension']
    MORE_INFO_KEYS = ['aggregates']

    def initialize(response_body, instance_klass = OpenStruct)
      @xml = response_body
      @instance_klass = instance_klass
    end

    def results
      @results ||= parse
    end
    
    def more_info
      @more_info || parse
    end
    
    private
      def parse
        parsed = XmlSimple.xml_in(@xml, { 'ForceArray' => ['entry'] })
      
        @more_info = @instance_klass.new(parsed.reject{ |k,v| !MORE_INFO_KEYS.include?(k) })
      
        entry_list = entries parsed['entry']
        entry_list.map do |entry|
          hash = values_for(entry).inject({}) do |h, v|
            h.merge(Garb.from_ga(v['name']) => v['value'])
          end

          @instance_klass.new(hash)
        end
      end

      def entries xml_entries
        [xml_entries].flatten.compact || []
      end

      def values_for(entry)
        KEYS.map {|k| entry[k]}.flatten.compact
      end
  end
end
