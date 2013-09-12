require 'log_parser'

describe LogParser do
  let(:file) { 'spec/fixtures/#channel_20130910.log' }
  let(:parser) { LogParser.open(file) }

  context "File load" do

    it "should open a file and return a LogParser" do
      parser.class.should be LogParser
    end

    it "should get the date of the logfile" do
      parser.date.should == "20130910"
    end

    it "should have a channel" do
      parser.channel.should == "#channel"
    end

  end

  context "parses lines" do

    let(:join_line) { %q{[08:43:53] *** Joins: codeofficer (~codeoffic@cpe-67-255-213-61.maine.res.rr.com)} }

    let(:part_line) { %q{[08:43:53] *** Parts: codeofficer (~codeoffic@cpe-67-255-213-61.maine.res.rr.com)} }

    let(:quit_line) { %q{[08:43:53] *** Quits: codeofficer (~codeoffic@cpe-67-255-213-61.maine.res.rr.com) (Remote host closed the connection)} }

    let(:standard_line) { %q{[08:43:53] <GitHub102> [ember.js^O] MrHus^O opened pull request #3374: A way to let users define custom made bound {{if}} statements (master^O...master^O)  http://git.io/4iSSmg} }

    let(:rename_line) { %q{[08:43:53] *** Oddskar_ is now known as Oddskar} }

    let(:today) { Time.parse("2013-09-10 08:43:53") }

    it "should parse a standard line" do
      l = parser.parse(standard_line)
      l.timestamp.should == today
      l.action.should == LogAction::MESSAGE
      l.username.should == "GitHub102"
      l.message.should == "[ember.js] MrHus opened pull request #3374: A way to let users define custom made bound {{if}} statements (master...master)  http://git.io/4iSSmg"
    end

    it "should parse a join line" do
      l = parser.parse(join_line)
      l.timestamp.should == today
      l.action.should == LogAction::JOIN
      l.username.should == "codeofficer"
      l.message.should == "(~codeoffic@cpe-67-255-213-61.maine.res.rr.com)"
    end

    it "should parse a quit line" do
      l = parser.parse(quit_line)
      l.timestamp.should == today
      l.action.should == LogAction::QUIT
      l.username.should == "codeofficer"
      l.message.should == "(~codeoffic@cpe-67-255-213-61.maine.res.rr.com) (Remote host closed the connection)"
    end

    it "should parse a part line" do
      l = parser.parse(part_line)
      l.timestamp.should == today
      l.action.should == LogAction::PART
      l.username.should == "codeofficer"
      l.message.should == "(~codeoffic@cpe-67-255-213-61.maine.res.rr.com)"
    end

    it "should parse a rename line" do
      l = parser.parse(rename_line)
      l.timestamp.should == today
      l.action.should == LogAction::MESSAGE
      l.username.should == "Oddskar_"
      l.message.should == "is now known as Oddskar"
    end
  end
end
