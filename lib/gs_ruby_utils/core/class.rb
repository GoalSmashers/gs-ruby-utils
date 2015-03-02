# https://github.com/danielb2/cattr/blob/master/lib/cattr.rb
class Class
  def cattr_accessor(*meths)
    cattr_writer(*meths)
    cattr_reader(*meths)
  end
  def cattr_reader(*meths)
    meths.each do |meth|
      self.class.send(:define_method, meth) do
        return nil unless class_variable_defined? "@@#{meth}"
        return class_variable_get "@@#{meth}"
      end
      class_variable_set("@@#{meth}", nil)
    end
  end
  def cattr_writer(*meths)
    meths.each do |meth|
      self.class.send(:define_method, :"#{meth}=") do |arg|
        class_variable_set("@@#{meth}", arg)
      end
    end
  end
end
