# Copyright (c) 2014-2021 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Utility glob class
class Glob
  NO_LEADING_DOT = '(?=[^\.])'.freeze

  def initialize(glob_string)
    @glob_string = glob_string
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  def to_regexp
    chars = @glob_string.gsub(%r{(\*\*\/\*)|(\*\*)}, '*').split('')
    in_curlies = 0, escaping = false
    chars.map do |char|
      if escaping
        escaping = false
        return char
      end
      case char
      when '*'
        '.*'
      when '?'
        '.'
      when '.'
        '\\.'
      when '{'
        in_curlies += 1
        '('
      when '}'
        if in_curlies.positive?
          in_curlies -= 1
          return ')'
        end
        return char
      when ','
        in_curlies.positive? ? '|' : char
      when '\\'
        escaping = true
        '\\'
      else
        char
      end
    end.join
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
end
