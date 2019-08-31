# frozen_string_literal: true

require 'singleton'

module Plugin::MiqHub
  class FileSystem
    include Singleton

    class << self
      def installed?(idname)
        instance.installed? idname
      end
    end

    def initialize
      @local_repos = []
      Dir.glob "#{Environment.PLUGIN_PATH}/*/.miqhub" do |f|
        @local_repos << (Repository.new JSON.parse f.read)
      end
    end

    def installed?(idname)
      @local_repos.any? { |repo| repo.idname == idname }
    end

    def install!(repo)
      installed? repo.idname and return

      Thread.new do
        path = Environment.PLUGIN_PATH / repo.name
        Dir.mkdir path
        extract_targz repo.download_uri.open, path
      end.then do
        @local_repos << repo
      end
    end

    def uninstall!(repo)
      installed? repo.idname or return

      rmdir path
    end

    def refresh!

    end

  private

    def extract_targz(file)
      Gem::Package::TarReader.new Zlib::GZipReader.open file
    end
  end
end
