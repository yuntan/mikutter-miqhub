# frozen_string_literal: true

require 'singleton'
require 'rubygems/package'
require 'zlib'

require_relative 'model/repository'

module Plugin::MiqHub
  class FileSystem
    include Singleton

    PLUGIN_DIR = Pathname.new "#{Environment::CONFROOT}/plugin"

    class << self
      def installed?(idname)
        instance.installed? idname
      end

      def install!(repo)
        instance.install! repo
      end

      def uninstall!(repo)
        instance.uninstall! repo
      end
    end

    def initialize
      # :slug => RepositoryのHash
      @local_repos = {}

      Dir.glob PLUGIN_DIR / '*' / '.miqhub' do |s|
        slug = (s.split File::Separator)[-2].to_sym
        h = JSON.parse (IO.read s), symbolize_names: true
        @local_repos[slug] = Repository.new h
      end
    end

    def installed?(idname)
      @local_repos.any? { |_, repo| repo.idname == idname }
    end

    def install!(repo)
      installed? repo.idname and return

      slug = nil
      Thread.new do
        path = PLUGIN_DIR
        tar_xf repo.archive_uri.open, path
        path /= "#{repo.name}-#{repo.default_branch_name}"
        yaml = (File.new path / '.mikutter.yml').read
        slug = (YAML.safe_load yaml, [Symbol])['slug']
        type_strict slug => Symbol
        newpath = PLUGIN_DIR / slug.to_s
        FileUtils.mv path, newpath
        File.open newpath / '.miqhub', 'w' do |f|
          f.write repo.to_json
        end
      end.next do
        @local_repos[slug] = repo
      end
    end

    def uninstall!(idname)
      installed? idname or return

      slug = @local_repos.find { |_, repo| repo.idname == idname }.first
      Thread.new do
        FileUtils.rm_r PLUGIN_DIR / slug.to_s
      end.next do
        @local_repos[slug] = nil
      end
    end

    def refresh!(repo) end

  private

    def tar_xf(file, path)
      tar = Gem::Package::TarReader.new Zlib::GzipReader.open file
      tar.rewind
      tar.each do |entry|
        entry.directory? and Dir.mkdir path / entry.full_name
        entry.file? and IO.copy_stream entry, path / entry.full_name
        entry.close
      end
      tar.close
    end
  end
end
