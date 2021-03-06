require 'spec_helper'

module FsBrowser
  describe Entry do
    let(:ext)       { '.txt' }
    let(:dir_name)  { 'folder' }
    let(:file_name) { "file#{ext}" }
    let(:root)      { Rails.root.join('spec/fixtures/filesystem') }
    let(:dir_path)  { File.join root, dir_name }
    let(:file_path) { File.join root, file_name }
    let(:dir_pathname) { Pathname.new(dir_path) }
    let(:file_pathname) { Pathname.new(file_path) }

    subject { Entry.new(dir_pathname) }

    it { subject.should respond_to :name }
    it { subject.should respond_to :ext }
    it { subject.should respond_to :type }
    it { subject.should respond_to :file? }
    it { subject.should respond_to :directory? }
    it { subject.should respond_to :realpath }
    it { subject.should respond_to :exist? }

    it 'represents the name, type and ext in json format' do
      json_hash = {
        :type => 'directory',
        :name => dir_name,
        :ext  => ''
      }.stringify_keys!
      subject.as_json.should == json_hash
    end

    context 'when directory' do
      it { subject.ext.should_not be_present }
      it { subject.type.should == 'directory' }
      it { subject.should be_directory }
      it { subject.should_not be_file }
      it { subject.name.should == dir_name }
    end

    context 'when file' do
      subject { Entry.new(file_pathname) }

      it { subject.should be_file }
      it { subject.should_not be_directory }
      it { subject.type.should == 'file' }
      it { subject.ext.should == ext }
    end
  end
end