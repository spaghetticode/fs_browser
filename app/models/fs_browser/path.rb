module FsBrowser
  class Path
    class NotFoundError < Exception; end
    class ParentError   < Exception; end

    BASE = '/'

    class << self
      attr_writer :base

      def base
        @base ||= BASE
      end
    end

    attr_reader :name, :entries

    def self.name_from_params(params)
      name = params[:id]
      name == 'root' ? base : name
    end

    def initialize(name)
      @name = name
      validate
      @entries = get_entries
    end

    def get_entries
      file_list.map do |entry_name|
        Entry.new(entry_name)
      end
    end

    def file_list
      list = Dir.glob("#{name}/*")
      list.unshift '..' unless root?
      list
    end

    def root?
      name == base
    end

    def base
      self.class.base
    end

    def validate
      raise NotFoundError unless File.exists?(name)
      # TODO use pathnames instead of strings all around in Path and Entry classes
      full_name = File.expand_path(name)
      full_base = File.expand_path(base)
      raise ParentError unless full_name =~ /\A#{full_base}/
    end
  end
end
