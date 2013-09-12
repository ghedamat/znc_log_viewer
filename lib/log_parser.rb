require 'time'
module LogAction
  MESSAGE = 'message'
  JOIN = 'join'
  PART = 'part'
  QUIT = 'quit'
end

class LogLine
  def initialize(args={})
    @timestamp = args[:timestamp]
    @action = args[:action]
    @username = args[:username]
    @message = args[:message]
    @date = args[:date]
  end

  def username
    @username.gsub(/<|>/,'')
  end

  def action
    case @action
    when /Joins/
      LogAction::JOIN
    when /Quits/
      LogAction::QUIT
    when /Parts/
      LogAction::PART
    else
      LogAction::MESSAGE
    end
  end

  def timestamp
    Time.parse(@timestamp + " " + @date)
  end

  def message
    @message.chomp
  end
end

class LogParser

  attr_reader :path, :channel, :date

  include Enumerable

  def self.open(path)
    LogParser.new(path)
  end

  def initialize(path)
    @date = extract_date(path)
    @channel = extract_channel(path)
    @path = path
  end

  def each
    IO.foreach(path) do |line|
      yield parse(line)
    end
  end

  def parse(line)
    m = match_line(line)

    timestamp = m[:timestamp]
    action = m[:action]
    username = m[:name]
    message = m[:message]

    LogLine.new timestamp: timestamp,
      action: action,
      username: username,
      message: message,
      date: @date
  end

  private

    def match_line(line)
      line.gsub!(/\^O/,'')#remove escape characters left by znc
      line.match(/(?<timestamp>\[\d\d\:\d\d:\d\d\]) (\*\*\* (?<action>Joins|Parts|Quits)?:?)?\s?(?<name><?\S+\>?)? (?<message>.+)?/)
    end

    def extract_date(path)
      File.basename(path, File.extname(path)).sub(/#\w+_/,'')
    end

    def extract_channel(path)
      File.basename(path, File.extname(path)).sub(/_\d+/,'')
    end

end
