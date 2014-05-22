class Proc
  def must_change(expression, by = nil)
    before = expression.kind_of?(Proc) ?
      expression.call :
      eval(expression)

    self.call

    after = expression.kind_of?(Proc) ?
      expression.call :
      eval(expression)

    if before.is_a?(String) && after.is_a?(String)
      if by == 0
        after.must_equal before
      else
        after.wont_equal before
      end
    else
      after.must_equal before + by
    end
  end

  def wont_change(expression)
    must_change(expression, 0)
  end
end
