class ActorTest < ActiveSupport::TestCase


  def test_send_email

    _user = User.create()
    _article = Article.create()
    _user_t  = User.create()

    mailing = _user.send_email(:new_enquiry,  :send_after => Time.now, :send_before => Time.now + 1.hour, :act_object => _article, :act_target => _user_t  )

    assert mailing.persisted?

  end

  def test_retrieves_the_stream_for_an_actor
    _user    = User.create()
    _article = Article.create()
    _user_t  = User.create()

    _user.send_email(:new_enquiry, :send_after => Time.now, :send_before => Time.now + 1.hour,  :act_object => _article, :act_target => _user_t  )
    _user.send_email(:new_enquiry,  :send_after => Time.now, :send_before => Time.now + 1.hour, :act_object => _article, :act_target => _user_t  )

    assert _user.logged_emails.size == 2

  end


  def test_retrieves_the_stream_for_a_particular_mailing_type
    _user = User.create()
    _article = Article.create()
    _user_t  = User.create()

    _user.send_email(:new_enquiry, :send_after => Time.now, :send_before => Time.now + 1.hour,  :act_object => _article, :act_target => _user_t  )
    _user.send_email(:new_enquiry,  :send_after => Time.now, :send_before => Time.now + 1.hour, :act_object => _article, :act_target => _user_t  )
    _user.send_email(:test_bond_type,  :send_after => Time.now, :send_before => Time.now + 1.hour, :act_object => _article, :act_target => _user_t  )

    assert _user.actor_logged_emails(:verb      => 'new_enquiry').size == 2
    assert _user.actor_logged_emails(:bond_type => 'global').size == 1

  end




end