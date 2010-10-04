# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Callbacks

  attribute :body

  before :validate, :do_before_validate
  after  :validate, :do_after_validate

  before :create,   :do_before_create
  after  :create,   :do_after_create

  before :save,     :do_before_save
  after  :save,     :do_after_save

  before :delete,   :do_before_delete
  after  :delete,   :do_after_delete

  before :update,   :do_before_update
  after  :update,   :do_after_update

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
  def do_before_validate() incr(:do_before_validate) end
  def do_after_validate()  incr(:do_after_validate)  end
  def do_before_create()   incr(:do_before_create)   end
  def do_after_create()    incr(:do_after_create)    end
  def do_before_save()     incr(:do_before_save)     end
  def do_after_save()      incr(:do_after_save)      end
  def do_before_update()   incr(:do_before_update)   end
  def do_after_update()    incr(:do_after_update)    end
  def do_before_delete()   incr(:do_before_delete)   end
  def do_after_delete()    incr(:do_after_delete)    end


  def incr(action)
    val = instance_variable_get("@#{ action }")
    val ||= 0
    val += 1

    instance_variable_set("@#{ action }", val)
  end
end

load File.expand_path('./callbacks_lint.rb', File.dirname(__FILE__))

