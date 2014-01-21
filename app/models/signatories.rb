require 'yaml'
require 'singleton'
class Signatories
  include Singleton

  FILE_PATH = "tmp/signatories.yml"
  def initialize
    clean
  end

  def populate(signatories)
    signatories.split('/').each do |signator|
      @all[signator] = signator
    end
  end

  def all
    @all
  end

  def clean
    @all={}
  end

  def find(term)
    @all.select{|key, hash| key.match(term) }.keys
  end

  def serialize(file = FILE_PATH)
    File.open(file, 'w') {|f| f.write @all.to_yaml }
  end

  def deserialize(file = FILE_PATH)
    @all = YAML::load_file(file)
  end
end 