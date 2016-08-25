module Checkwildcard

  def has_included_resources_is_false_when_nil
     false if @include_param.nil?
  end

  def check_has_included_resources_is_true_or_false_with_wildcard_and_non_params_or_both
    i = 0
    j = 0
    @params_arr.each do |e|
      puts e.include? '*'
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

  def model_includes_single_or_multiple_two_level_resources
    array = @include_param.split(",")
    puts array.inspect
    temp = []
    arr = []
    h = Hash.new { |h, k| h[k] = [] }

    array.each_index do |i|
      if array[i].include? '.'
        temp =array[i].to_s.split(".")
        array[i]=temp
      end
    end

    array.each do |a|
      if array.length ==2
        if array[0][0]!=array[1][0]
          arr<<{a[0].to_sym => [a[1].to_sym]}
        else
          h[a[0].to_sym]<<a[1].to_sym
        end
      else
        arr<<{a[0].to_sym => [a[1].to_sym]}
      end
    end

    arr<<h if h.any?
    arr
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

end
