class FuzzyHash
  
  def initialize(init_hash = nil)
    @regexes = []
    @hash_reverse = {}
    @regexes_reverse = {}
    @hash = {}
    init_hash.each{ |key,value| self[key] = value } if init_hash
  end
  
  def clear
    @hash.clear
    @regexes.clear
    @hash_reverse.clear
    @regexes_reverse.clear
  end
  
  def ==(o)
    o.instance_variable_get(:@hash) == @hash &&
    o.instance_variable_get(:@regexes) == @regexes
  end
  
  def empty?
    @hash.empty? && @regexes.empty?
  end
  
  def keys
    @hash.keys + @regexes.collect{|r| r.first}
  end
  
  def values
    @hash.values + @regexes.collect{|r| r.last}
  end
  
  def each
    @hash.each{|k,v| yield k,v }
    @regexes.each{|v| yield v.first, v.last }
  end
  
  def delete_value(value)
    @hash.delete(@hash_reverse[value]) || ((rr = @regexes_reverse[value]) && @regexes.delete_at(rr[0]))
  end
  
  def []=(key, value)
    case key
    when Regexp
      @regexes << [key, value]
      @regex_test = nil
      @regexes_reverse[value] = [@regexes.size - 1, key, value]
    else
      @hash[key] = value
      @hash_reverse[value] = key
    end
  end
  
  def replace(src, dest)
    if @hash_reverse.key?(src)
      key = @hash_reverse[src]
      @hash[key] = dest
      @hash_reverse.delete(src)
      @hash_reverse[dest] = key
    elsif @regexes_reverse.key?(src)
      key = @regexes_reverse[src]
      @regexes[rkey[0]] = [rkey[1], dest]
      @regexes_reverse.delete(src)
      @regexes_reverse[dest] = [rkey[0], rkey[1], dest]
    end
  end
  
  def [](key)
    @hash.key?(key) ? @hash[key] : (lookup = regex_lookup(key)) && lookup && lookup.first
  end
  
  def match_with_result(key)
    if @hash.key?(key)
      [@hash[key], key]
    else
      regex_lookup(key)
    end
  end
  
  private
  def regex_test
    @regex_test ||= Regexp.new(@regexes.collect{|r| "(#{r[0]})"} * '|')
  end
  
  def regex_lookup(key)
    if !@regexes.empty? && key.is_a?(String) && (data = regex_test.match(key))
      (data_array = data.to_a).each_index do |i|
        break [@regexes[i].last, data_array.at(i+1)] if data_array.at(i+1)
      end
    end
  end
  
end