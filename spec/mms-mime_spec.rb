require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

ROOT_DIR = File.expand_path(File.dirname(__FILE__) + '/..')

RSpec.describe Mime::Mms::Parser, "when first created" do
  it "should not be nil" do
    p = Mime::Mms::Parser.new
    expect(p).to_not be_nil
    expect(p.message.class).to eq(Mime::Mms::Message)
    expect(p.message.subject).to be_nil
  end
end

RSpec.describe Mime::Mms::Parser, "when initialized from files" do
  %w(mms-1 mms-2 mms-3 mms-4 mms-5).each do |file|
    it "should parse file #{file}" do
      p = Mime::Mms::Parser.new :file => "#{ROOT_DIR}/spec/fixtures/#{file}.bin"
      m = p.parse
      expect(m.parts).to_not be_nil
      expect(m.parts.size).to be > 0

      expect(m.xml_parts).not_to be_nil
      expect(m.xml_parts.size).to eq(1)

      expect(m.image_parts).not_to be_nil
      expect(m.image_parts.size).to be > 0

      unless file == "mms-3"
        expect(m.text_parts).not_to be_nil
        expect(m.text_parts.size).to be > 0
        expect(m.text).not_to be_nil
      end
    end
  end

  it "should extract subject, shortcode and number from binary-encoded file" do
    p = Mime::Mms::Parser.new :file => "#{ROOT_DIR}/spec/fixtures/mms-1.bin"
    m = p.parse
    expect(m.subject).to be_nil
    expect(m.from).to eq("14155556666")
    expect(m.to).to eq("43333")
  end

  it "should extract subject, shortcode and number from base64 encoded file" do
    p = Mime::Mms::Parser.new :file => "#{ROOT_DIR}/spec/fixtures/mms-5.bin"
    m = p.parse
    expect(m.subject).not_to be_nil
    expect(m.subject).to eq("Test group of messages")
    expect(m.text).to eq("Test MM")
    expect(m.from).to eq("77777")
    expect(m.to).to eq("1")
    # File.open("image.jpg","w") { |f| f.write m.image_parts.first.body }
  end

end

