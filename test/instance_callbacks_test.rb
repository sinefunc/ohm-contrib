# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Callbacks

  attribute :body

  def validate
    super

    assert_present :body
  end

  def did?(action)
    instance_variable_get("@#{ action }")
  end

  def count(action)
    instance_variable_get("@#{ action }")
  end

protected
  def before_validate() incr(:do_before_validate) end
  def after_validate()  incr(:do_after_validate)  end
  def before_create()   incr(:do_before_create)   end
  def after_create()    incr(:do_after_create)    end
  def before_save()     incr(:do_before_save)     end
  def after_save()      incr(:do_after_save)      end
  def before_update()   incr(:do_before_update)   end
  def after_update()    incr(:do_after_update)    end
  def before_delete()   incr(:do_before_delete)   end
  def after_delete()    incr(:do_after_delete)    end


  def incr(action)
    val = instance_variable_get("@#{ action }")
    val ||= 0
    val += 1

    instance_variable_set("@#{ action }", val)
  end
end

load File.expand_path('./callbacks_lint.rb', File.dirname(__FILE__))

