class Proc
  def must_change(expression, by)
    before = expression.kind_of?(Proc) ?
      expression.call :
      eval(expression)

    self.call

    after = expression.kind_of?(Proc) ?
      expression.call :
      eval(expression)

    after.must_equal before + by
  end

  def wont_change(expression)
    must_change(expression, 0)
  end
end
