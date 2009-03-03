require 'lib/fuzzy_hash'

describe "Fuzzy hash" do

  it "should accept strings and retrieve based on them" do
    l = FuzzyHash.new
    l['asd'] = 'qwe'
    l['asd'].should == 'qwe'
  end
  
  it "should accept regexs too" do
    l = FuzzyHash.new
    l[/asd.*/] = 'qwe'
    l['asdqweasd'].should == 'qwe'
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

end