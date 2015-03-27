class ROBDD
  attr_accessor :t, :h

  def initialize
    @t = Table_T.new
    @h = Table_H.new
  end
  
  def minterm_set_var_val(minterm, var_num, var_val)
    # minterm is a string representing the minterm, eg 11x for x1x2 in a 3 var case
    # var_num is 1 based
    # var_val is 0 or 1 (i.e binary)
    if(minterm[var_num-1] == 'x') # variable is absent in minterm
      return minterm
    elsif(minterm[var_num-1] == var_val.to_s) 
      minterm[var_num-1] = 'x' # the variable would disappear in this case
    else
      minterm = '0'      
    end
    
    return minterm
  end
  
  def function_set_var_val(func, var_num, var_val, total_num_of_vars)
    # func is an array of strings representing the sum of minterms, eg 11x + x01
    # var_num is 1 based
    # var_val is 0 or 1 (i.e binary)
    #func = _func.clone
    minterm_equals_1 = 'x' * total_num_of_vars
    func_result = []
    
    (0...func.length).each do |i|
      minterm_result = minterm_set_var_val(func[i], var_num, var_val)
      
      if(minterm_result == minterm_equals_1)
        return ['1'] # the whole function value is 1 if any minterm is 1
      elsif (minterm_result == '0')
        # a zero minterm is redundant, so no need to add it to the function's result
      else
        func_result << minterm_result
      end
    end
    
    if func_result.length == 0  # all the minterms returned as zero
      return ['0']
    else
      return func_result
    end    
  end

  def make(triple)
    if triple.l == triple.h
      return triple.l
    elsif h.member?(triple)
      return h.lookup(triple)
    else
      u = t.add(triple)
      h.insert(triple, u)
      return u
    end
  end

  def build_func(func, i, num_of_vars)
    #func = _func.clone
    # cases when the end nodes (i.e 0 or 1) is reached
    if func.length == 1
      if func[0] == '0'
        return 0
      elsif func[0] == '1'
        return 1
      end
    end

    if i > num_of_vars
      if func.length == 1 && func[0] == '0'
        return 0
      else
        return 1
      end
    else
      puts "t.t: #{t.t.inspect}"
      puts "Calling v0:"
      puts "i is: #{i.inspect}"
      puts "func: #{func.inspect}"

      v0 = build_func(function_set_var_val(Marshal.load(Marshal.dump(func)), i, 0, num_of_vars), i+1, num_of_vars)

      puts "return value of v0: #{v0.inspect}"
      puts "Calling v1:"
      puts "i is: #{i.inspect}"
      puts "func: #{func.inspect}"

      v1 = build_func(function_set_var_val(Marshal.load(Marshal.dump(func)), i, 1, num_of_vars), i+1, num_of_vars)
      puts "return value of v1: #{v1.inspect}"

      return make(Triple.new(i, v0, v1))
    end
  end

  # def deep_copy_func(input)
  #   output = []
  #
  #   (0...input.length).each do |i|
  #     output << input[i]
  #   end
  #
  #   output
  # end
end

# Test Area
#
# r = ROBDD.new
# min = 'x01'
# retVal = r.minterm_set_var_val(min, 2, 0)
# puts retVal
