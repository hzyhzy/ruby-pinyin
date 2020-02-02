module PinYin
  module Backend
    class EZSeg

      def initialize(override_files=[])
        @override_files = override_files || []
      end



      def romanize(str, tone=nil, include_punctuations=false)
        return [] unless str && str.length > 0
        words = segment str

        res = []
        words.each do |word|
          if str && !str.empty?
            word.unpack('U*').each_with_index do |t,idx|
              code = sprintf('%x',t).upcase
              readings = codes[code]

              if readings
                multiple_arr = readings.collect{|one| Value.new(format([one], tone), false)}
                res << (multiple_arr.length > 1 ? multiple_arr : multiple_arr[0])
              else
                val = [t].pack('U*')
                if val =~ /^[0-9a-zA-Z\s]*$/ # 复原，去除特殊字符,如全角符号等。
                  if res.last && res.last.respond_to?(:english?) && res.last.english?
                    res.last << Value.new(val, true)
                  elsif val != ' '
                    res << Value.new(val, true)
                  end
                elsif include_punctuations
                  val = [Punctuation[code]].pack('H*') if Punctuation.include?(code)
                  (res.last ? res.last : res) << Value.new(val, false)
                end
              end
            end
          end
        end
        res
      end

      private

      def codes
        return @codes if @codes

        @codes = {}
        src = File.expand_path('../../data/Mandarin.dat', __FILE__)
        @override_files.unshift(src).each do |file|
          load_codes_from(file)
        end
        @codes
      end

      def load_codes_from(file)
        File.readlines(file).map do |line|
          code, readings = line.split(' ')
          @codes[code] = readings.split(',')
        end
      end

      def format(readings, tone)
        case tone
        when :unicode
          readings[0]
        when :ascii, true
          PinYin::Util.to_ascii(readings[0])
        else
          PinYin::Util.to_ascii(readings[0], false)
        end
      end

      def segment(str)
        words = []
        str.split('').each do |s|
          words.push(s) unless s =~ Punctuation.chinese_regexp
        end

        words
      end

      # def apply(base, patch)
      #   result = []
      #   base.each_with_index do |char, i|
      #     if patch[i].nil?
      #       result.push char
      #     elsif char =~ Punctuation.regexp
      #       result.push Value.new("#{patch[i]}#{$1}", char.english?)
      #     else
      #       result.push Value.new(patch[i], char.english?)
      #     end
      #   end
      #   result
      # end


    end
  end
end