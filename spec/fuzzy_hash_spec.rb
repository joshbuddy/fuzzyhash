require 'lib/fuzzy_hash'

describe "Fuzzy hash" do

  it "should accept strings and retrieve based on them" do
    l = FuzzyHash.new
    l['asd'] = 'qwe'
    l['asd'].should == 'qwe'
  end
  
  it "should accept strings, but the second time you set the same string, it should overwrite" do
    l = FuzzyHash.new
    l['asd'] = 'asd'
    l['asd'] = 'qwe'
    l['asd'].should == 'qwe'
  end

  it "should accept regexs too" do
    l = FuzzyHash.new
    l[/asd.*/] = 'qwe'
    l['asdqweasd'].should == 'qwe'
  end

  it "should accept regexs too, but the second time you set the same regex, it should overwrite" do
    l = FuzzyHash.new
    l[/asd/] = 'asd'
    l[/asd/] = 'qwe'
    l['asdqweasd'].should == 'qwe'
  end

  it "should accept regexs too with the match" do
    l = FuzzyHash.new
    l[/asd.*/] = 'qwe'
    l.match_with_result('asdqweasd').should == ['qwe', 'asdqweasd']
  end

  it "should prefer string to regex matches" do
    l = FuzzyHash.new
    l['asd'] = 'qwe2'
    l[/asd.*/] = 'qwe'
    l['asd'].should == 'qwe2'
  end

  it "should allow nil keys" do
    l = FuzzyHash.new
    l[nil] = 'qwe2'
    l['asd'] = 'qwe'
    l['asd'].should == 'qwe'
    l[nil].should == 'qwe2'
  end

  it "should allow boolean keys" do
    l = FuzzyHash.new
    l[false] = 'false'
    l[true] = 'true'
    l[/.*/] = 'everything else'
    l[true].should == 'true'
    l[false].should == 'false'
    l['false'].should == 'everything else'
  end

  it "always fuzzy should accept .. well.. anything" do
    l = FuzzyHash.always_fuzzy
    l[1..3] = '1 to 3'
    l[4] = 'four'
    l[5..10] = '5 and up'
    l[/.*/] = 'whatev'
    
    l[2].should  == '1 to 3'
    l[4].should  == 'four'
    l[8].should  == '5 and up'
    l['something'].should == 'whatev'
  end

  it "should pick between the correct regex" do
    hash = FuzzyHash.new
    hash[/^\d+$/] = 'number'
    hash[/.*/] = 'something'
    hash['123asd'].should == 'something'
  end

  it "should be able to delete by value for hash" do
    l = FuzzyHash.new
    l[nil] = 'qwe2'
    l['asd'] = 'qwe'
    l['asd'].should == 'qwe'
    l[nil].should == 'qwe2'
    l.delete_value('qwe2')
    l[nil].should == nil
  end

  it "should be able to delete by value for regex" do
    l = FuzzyHash.new
    l[/qwe.*/] = 'qwe2'
    l['asd'] = 'qwe'
    l['asd'].should == 'qwe'
    l['qweasd'].should == 'qwe2'
    l.delete_value('qwe2')
    l['qweasd'].should == nil
  end

  it "should iterate through the keys" do
    l = FuzzyHash.new
    l[/qwe.*/] = 'qwe2'
    l['asd'] = 'qwe'
    l['zxc'] = 'qwe'
    ([/qwe.*/,'asd','zxc'] & l.keys).size.should == 3
  end

  it "should iterate through the values" do
    l = FuzzyHash.new
    l[/qwe.*/] = 'qwe2'
    l['asd'] = 'qwe'
    l['zxc'] = 'qwelkj'
    (['qwe2','qwe','qwelkj'] & l.values).size.should == 3
  end

  it "should clear" do
    l = FuzzyHash.new
    l[/qwe.*/] = 'qwe2'
    l['asd'] = 'qwe'
    l['zxc'] = 'qwelkj'
    l.clear
    l.empty?.should == true
  end

  it "should ==" do
    l_1 = FuzzyHash.new
    l_1[/qwe.*/] = 'qwe2'
    l_1['asd'] = 'qwelkj'
    l_1['zxc'] = 'qwe'
    l_2 = FuzzyHash.new
    l_2['zxc'] = 'qwe'
    l_2['asd'] = 'qwelkj'
    l_2[/qwe.*/] = 'qwe2'
    l_1.should == l_2
  end

  it "should return the value when adding the value" do
    h = FuzzyHash.new
    (h[/asd/] = '123').should == '123'
    (h['qwe'] = '123').should == '123'
  end

end