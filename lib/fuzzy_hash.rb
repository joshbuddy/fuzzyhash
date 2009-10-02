require 'set'

class FuzzyHash
  
  def self.always_fuzzy(init_hash)
    hash = new(init_hash)
    hash.classes_to_fuzz = nil    
    hash
  end
  
  
  def initialize(init_hash = nil, classes_to_fuzz = nil)
    @regexes = []
    @hash_reverse = {}
    @regexes_reverse = {}
    @hash = {}
    @classes_to_fuzz = classes_to_fuzz || [Regexp]
    @classes_to_fuzz = Set.new(@classes_to_fuzz)
    init_hash.each{ |key,value| self[key] = value } if init_hash
  end
  
  def clear
    hash.clear
    regexes.clear
    hash_reverse.clear
    regexes_reverse.clear
  end
  
  def size
    hash.size + regexes.size
  end
  alias_method :count, :size
  
  
  def ==(o)
    o.is_a?(FuzzyHash)
    o.send(:hash) == hash &&
    o.send(:regexes) == regexes
  end
  
  def empty?
    hash.empty? && regexes.empty?
  end
  
  def keys
    hash.keys + regexes.collect{|r| r.first}
  end
  
  def values
    hash.values + regexes.collect{|r| r.last}
  end
  
  def each
    hash.each{|k,v| yield k,v }
    regexes.each{|v| yield v.first, v.last }
  end
  
  def delete_value(value)
    hash.delete(hash_reverse[value]) || ((rr = regexes_reverse[value]) && regexes.delete_at(rr[0]))
  end
  
  def []=(key, value)
    if classes_to_fuzz.nil? || classes_to_fuzz.include?(key.class)
      regexes << [key, value]
      regex_test = nil
      regexes_reverse[value] = [regexes.size - 1, key, value]
    else
      hash[key] = value
      hash_reverse[value] = key
    end
    value
  end
  
  def replace(src, dest)
    if hash_reverse.key?(src)
      key = hash_reverse[src]
      hash[key] = dest
      hash_reverse.delete(src)
      hash_reverse[dest] = key
    elsif regexes_reverse.key?(src)
      key = regexes_reverse[src]
      regexes[rkey[0]] = [rkey[1], dest]
      regexes_reverse.delete(src)
      regexes_reverse[dest] = [rkey[0], rkey[1], dest]
    end
  end
  
  def [](key)
    hash.key?(key) ? hash[key] : (lookup = regex_lookup(key)) && lookup && lookup.first
  end
  
  def match_with_result(key)
    if hash.key?(key)
      [hash[key], key]
    else
      regex_lookup(key)
    end
  end
  
  private
  
  attr_reader :regexes, :hash_reverse, :regexes_reverse, :hash, :classes_to_fuzz
  
  
  
  def regex_test
    unless @regex_test
      @regex_test = Object.new
      @regex_test.instance_variable_set(:'@regexes', regexes)
      method = "
        def match(str)
          case str
      "
      regexes.each_with_index do |reg, index|
        method << "when #{reg.first.inspect}: [@regexes[#{index}][1], str]\n"
      end
      method << "end\nend\n"
      @regex_test.instance_eval method
    end
    @regex_test
  end
  
  def regex_lookup(key)
    if !regexes.empty? && key.is_a?(String) && (value = regex_test.match(key))
      value
    end
  end
  
end