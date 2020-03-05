# rubocop:disable all

require 'consenter/version'

require 'io/console'

class Consenter # :nodoc:

  VALID_RESPONSES = {
    'y' => 'yes to this',
    'n' => 'no to this',
    'Y' => 'yes to this and all remaining',
    'N' => 'no to this and all remaining',
    'q' => 'quit',
    '?' => 'help',
  }.freeze

  private_constant :VALID_RESPONSES

  HELP = VALID_RESPONSES.map { |k, v|
    "#{k} - #{v}"
  }.join($/).freeze

  private_constant :HELP

  ANSWERS = VALID_RESPONSES.keys.join(',').freeze

  private_constant :ANSWERS

  def initialize(prompt = '%s', options = {})
    @prompt = prompt + ' [' + ANSWERS + '] '

    @inspector  = options.fetch(:inspector, :to_s)
    @no_to_all  = options.fetch(:none, false)
    @yes_to_all = options.fetch(:all, false)
  end

  def consent_for?(arg)
    key_pressed = \
    case
    when @yes_to_all then 'y'
    when @no_to_all  then 'n'
    else
      loop do
        description = case @inspector
                      when Symbol then arg.send(@inspector)
                      when Method then @inspector.call(arg)
                      end
        IO.console.print format(@prompt, description)
        case answer = (key = IO.console.gets) ? key.strip : nil
        when *['y', 'n'] then break answer
        when 'Y'         then @yes_to_all = true and break 'y'
        when 'N'         then @no_to_all  = true and break 'n'
        when 'q'         then break nil
        when nil         then break nil # CTRL-D
        when '?'         then IO.console.puts HELP
        else                  IO.console.puts HELP
        end
      end
    end
    key_pressed && key_pressed == 'y'
  end

  private :consent_for?

  def for(enumerable, &block)
    enumerable.each do |arg|
      case consent_for? arg
      when true  then block.yield(arg) # user pressed 'y' or 'Y'
      when false then nil              # user pressed 'n' or 'N'
      when nil   then break            # user pressed 'q'
      end
    end
  end

end

module Enumerable # :nodoc:
  def each_consented(prompt = '%s', options = {})
    unless block_given?
      return to_enum(__method__, prompt, options) do size; end
    end
    Consenter.new(prompt, options).for(self) do |*args|
      yield(*args)
    end
  end
end

# rubocop:enable all
