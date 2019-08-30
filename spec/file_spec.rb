require "spec_helper"

describe ChessBoy::Image do
  let(:file_name) { "test.jpg" }

  around(:each) do |example|
    File.delete(file_name) if File.exists?(file_name)
    example.run
    File.delete(file_name) if File.exists?(file_name)
  end

  describe "#write!" do
    it "Writes an image to the given location" do
      image = ChessBoy::Image.new("Hello World", file_name)

      expect(image.write!).to be_a(File)
      expect(File.exists?(file_name)).to eq(true)
    end
  end
end
