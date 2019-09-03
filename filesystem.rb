# frozen_string_literal: true

require 'singleton'
require 'rubygems/package'
require 'zlib'

require_relative 'model_ext'

module Plugin::MiqHub
  class FileSystem
    include Singleton

    PLUGIN_DIR = Pathname.new "#{Environment::CONFROOT}/plugin"
    YAML_NAME = '.miqhub.yml'

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

      Dir.glob PLUGIN_DIR / '*' / YAML_NAME do |s|
        slug = (s.split File::Separator)[-2].to_sym
        h = load_yaml File.new s
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
        yaml = load_yaml File.new path / '.mikutter.yml'
        slug = yaml[:slug]
        type_strict slug => Symbol
        newpath = PLUGIN_DIR / slug.to_s
        FileUtils.mv path, newpath
        File.open newpath / YAML_NAME, 'w' do |f|
          f.write repo.to_yaml
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

    def load_yaml(io)
      YAML.safe_load io.read, [Symbol, Time], symbolize_names: true
    end
  end
end
