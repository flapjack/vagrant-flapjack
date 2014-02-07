# https://github.com/bernd/webmachine-test/blob/master/lib/webmachine/test/backports/uri.rb
#
# :stopdoc:
#
# Stolen from ruby core's uri/common.rb, with modifications to support 1.8.x
#
# https://github.com/ruby/ruby/blob/trunk/lib/uri/common.rb
#
# (via rack)

module URI
  TBLENCWWWCOMP_ = {} # :nodoc:
  256.times do |i|
    TBLENCWWWCOMP_[i.chr] = '%%%02X' % i
  end
  TBLENCWWWCOMP_[' '] = '+'
  TBLENCWWWCOMP_.freeze
  TBLDECWWWCOMP_ = {} # :nodoc:
  256.times do |i|
    h, l = i>>4, i&15
    TBLDECWWWCOMP_['%%%X%X' % [h, l]] = i.chr
    TBLDECWWWCOMP_['%%%x%X' % [h, l]] = i.chr
    TBLDECWWWCOMP_['%%%X%x' % [h, l]] = i.chr
    TBLDECWWWCOMP_['%%%x%x' % [h, l]] = i.chr
  end
  TBLDECWWWCOMP_['+'] = ' '
  TBLDECWWWCOMP_.freeze

  # Encode given +s+ to URL-encoded form data.
  #
  # This method doesn't convert *, -, ., 0-9, A-Z, _, a-z, but does convert SP
  # (ASCII space) to + and converts others to %XX.
  #
  # This is an implementation of
  # http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
  #
  # See URI.decode_www_form_component, URI.encode_www_form
  def self.encode_www_form_component(s)
    str = s.to_s
    if RUBY_VERSION < "1.9" && $KCODE =~ /u/i
      str.gsub(/([^ a-zA-Z0-9_.-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end.tr(' ', '+')
    else
      str.gsub(/[^*\-.0-9A-Z_a-z]/) {|m| TBLENCWWWCOMP_[m]}
    end
  end
end
