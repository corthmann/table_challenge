require 'active_support/core_ext/hash/indifferent_access'

class Movie

  def self.find_all(query: nil, page: 1, per_page: 25)
    database.map do |entry|
      next unless query && entry['movie_title'].downcase.include?(query.downcase)
      new(entry)
    end.compact.slice(page.to_i*per_page.to_i-per_page.to_i, per_page.to_i)
  end

  def self.database
    JSON.parse(File.read(File.join(Rails.root,'db','data.json')))
  end

  def initialize(attributes = {})
    @attributes = attributes.with_indifferent_access
  end

  def [](key)
    @attributes[key.to_sym]
  end

  def to_hash
    @attributes.to_h
  end

  private

  def method_missing(method_sym, *arguments)
    if @attributes.include?(method_sym)
      attribute_name = method_sym.to_s.gsub(/(\?$)|(=$)/, '')
      self.instance_eval build_attribute_getter(attribute_name)
      send(method_sym, *arguments)
    else
      super(method_sym, *arguments)
    end
  end

  def build_attribute_getter(attribute_name)
    "def #{attribute_name}
       @attributes[:#{attribute_name}]
     end"
  end
end
