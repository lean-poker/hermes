require 'mongo'
require 'mongo/functional/uri_parser'

class DocumentStore
  include Mongo

  def initialize(connection_string)
    @db = Mongo::URIParser.new(connection_string).connection.db
  end

  def [](collection)
    @db[collection]
  end

  def self.connect(connection_string)
    @instance = DocumentStore.new(connection_string)
  end

  def self.instance
    @instance
  end

  def self.[](collection)
    instance[collection]
  end

  def file_sysyem
    Mongo::GridFileSystem.new(@db)
  end

  def self.file_system
    instance.file_sysyem
  end
end