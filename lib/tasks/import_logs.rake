require 'log_parser'

def import_log(path)
  parser = LogParser.open(path)

  c = Channel.find_or_create_by_name(parser.channel)

  parser.each do |line|
    Line.create channel: c,
      username: line.username,
      action: line.action,
      timestamp: line.timestamp,
      message: line.message
  end
end

desc 'Import a single irc.log file'
task :import_log, [:path] => :environment do |t, args|
  import_log(args[:path])
end

desc 'Import mutiple irc.log files from a directory'
task :import_logs, [:path] => :environment do |t, args|
  files = Rake::FileList.new(args[:path]+'*')
  files.each do |file|
    import_log(file)
  end
end
