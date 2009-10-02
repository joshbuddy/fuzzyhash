require 'set'

class FuzzyHash
  
  def self.always_fuzzy(init_hash)
    hash = new(init_hash)
    hash.classes_to_fuzz = nil    
    hash
  end
  
  
  def initialize(init_hash = nil, classes_to_fuzz = nil)
    @fuzzies = []
    @hash_reverse = {}
    @fuzzies_reverse = {}
    @hash = {}
    @classes_to_fuzz = classes_to_fuzz || [Regexp]
    @classes_to_fuzz = Set.new(@classes_to_fuzz)
    init_hash.each{ |key,value| self[key] = value } if init_hash
  end
  
  def clear
    hash.clear
    fuzzies.clear
    hash_reverse.clear
    fuzzies_reverse.clear
  end
  
  def size
    hash.size + fuzzies.size
  end
  alias_method :count, :size
  
  
  def ==(o)
    o.is_a?(FuzzyHash)
    o.send(:hash) == hash &&
    o.send(:fuzzies) == fuzzies
  end
  
  def empty?
    hash.empty? && fuzzies.empty?
  end
  
  def keys
    hash.keys + fuzzies.collect{|r| r.first}
  end
  
  def values
    hash.values + fuzzies.collect{|r| r.last}
  end
  
  def each
    hash.each{|k,v| yield k,v }
    fuzzies.each{|v| yield v.first, v.last }
  end
  
  def delete_value(value)
    hash.delete(hash_reverse[value]) || ((rr = fuzzies_reverse[value]) && fuzzies.delete_at(rr[0]))
  end
  
  def []=(key, value)
    if classes_to_fuzz.nil? || classes_to_fuzz.include?(key.class)
      fuzzies << [key, value]
      reset_fuzz_test!
      fuzzies_reverse[value] = [fuzzies.size - 1, key, value]
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
    elsif fuzzies_reverse.key?(src)
      key = fuzzies_reverse[src]
      fuzzies[rkey[0]] = [rkey[1], dest]
      fuzzies_reverse.delete(src)
      fuzzies_reverse[dest] = [rkey[0], rkey[1], dest]
    end
  end
  
  def [](key)
    hash.key?(key) ? hash[key] : (lookup = fuzzy_lookup(key)) && lookup && lookup.first
  end
  
  def match_with_result(key)
    if hash.key?(key)
      [hash[key], key]
    else
      fuzzy_lookup(key)
    end
  end
  
  private
  
  attr_reader :fuzzies, :hash_reverse, :fuzzies_reverse, :hash, :classes_to_fuzz
  attr_writer :fuzz_test
  
  def reset_fuzz_test!
    self.fuzz_test = nil
  end
  
  def fuzz_test
    unless @fuzz_test
      @fuzz_test = Object.new
      @fuzz_test.instance_variable_set(:'@fuzzies', fuzzies)
      method = "
        def match(str)
          case str
      "
      fuzzies.each_with_index do |reg, index|
        method << "when #{reg.first.inspect}: [@fuzzies[#{index}][1], str]\n"
      end
      method << "end\nend\n"
      @fuzz_test.instance_eval method
    end
    @fuzz_test
  end
  
  def fuzzy_lookup(key)
    if !fuzzies.empty? && key.is_a?(String) && (value = fuzz_test.match(key))
      value
    end
  end
  
end