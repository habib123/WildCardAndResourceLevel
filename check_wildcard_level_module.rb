module Checkwildcard

  def has_included_resources_is_false_when_nil
     false if @include_param.nil?
  end

  def check_has_included_resources_is_true_or_false_with_wildcard_and_non_params_or_both
    i = 0
    j = 0
    @params_arr.each do |e|
       if e.include? '*'
           i =  i+1
       else
          j = j+1
       end
    end
    check = i>0 && j==0 ? false : true
  end

  def included_resources_returns_only_non_wildcards
    @params_arr.reject { |e| e.include? '*'}
  end

  def model_includes_single_or_multiple_three_level_resources
    array = @include_param.split(",")
    arr=[]
    h = Hash.new { |h, k| h[k] = [] }
    internal_h =  Hash.new{|h, k| h[k]= [] }

    array.each_index do |i|
      if array[i].include? '.'
        item = array[i].to_s.split(".")
        if !item[2].nil?
          internal_h[item[1].to_sym] << item[2].to_sym
          h[item[0].to_sym] = [internal_h]
          arr<<h
        end
      else
        arr<<array[i].to_s.to_sym
      end
    end
    arr.reject! {|key| h.include? key}
    arr.uniq
  end

  def check_two_level
    flag = false
    @params_arr.each do |e|
      if e.include?'.'
        item = e.to_s.split(".")
        if item.length == 2
          flag = true
          break
        end
      end
    end
    flag
  end

  def model_includes_single_or_multiple_two_level_resources
    array = @params_arr
    temp = []
    arr = []
    a = []
    h = Hash.new { |h, k| h[k] = [] }

    array.each_index do |i|
      if array[i].include? '.'
        temp =array[i].to_s.split(".")
        temp[0] = temp[0].to_s.to_sym
        temp[1]=temp[1].to_s.to_sym
        array[i]=temp
      end
    end
    arr= array.group_by(&:first)
    arr=array.group_by(&:first).map{ |k,a| [k,a.map(&:last)] }
    arr= Hash[ array.group_by(&:first).map{ |k,a| [k,a.map(&:last)] } ]
    arr.each do |hs|
      a<< {hs[0] => hs[1]}
    end
    a
  end

end
