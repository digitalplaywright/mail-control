class DefinitionTest < ActiveSupport::TestCase

  def definition_dsl
    dsl = MailControl::DefinitionDSL.new(:new_enquiry)
    dsl.actor(:User)
    dsl.act_object(:Article)
    dsl.act_target(:Volume)
    dsl
  end

  def test_initialization
    _definition_dsl = definition_dsl
    _definition     = MailControl::Definition.new(_definition_dsl)

    assert _definition.actor      == :User
    assert _definition.act_object == :Article
    assert _definition.act_target == :Volume

  end

  def test_register_definition_and_return_new_definition

    assert MailControl::Definition.register(definition_dsl).is_a?(MailControl::Definition)

  end

  def test_register_invalid_definition

    assert MailControl::Definition.register(false)  == false

  end

  def test_return_registered_definitions

    MailControl::Definition.register(definition_dsl)
    assert MailControl::Definition.registered.size > 0

  end

  def test_return_definition_by_name
    assert MailControl::Definition.find(:new_enquiry).name == :new_enquiry

  end

  def test_raise_exception_if_invalid_queued_task

    assert_raises(MailControl::InvalidLoggedEmail){ MailControl::Definition.find(:unknown_queued_task) }

  end

end