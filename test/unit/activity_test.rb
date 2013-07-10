class LoggedEmailTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end

  def test_register_definition

    @definition = LoggedEmail.queued_task(:test_queued_task) do
      actor :user, :cache => [:full_name]
      act_object :listing, :cache => [:title, :full_address]
      act_target :listing, :cache => [:title]
    end

    assert @definition.is_a?(MailControl::Definition)

  end

  def test_publish_new_queued_task
    _user    = User.create()
    _article = Article.create()
    _user_t  = User.create()

    _queued_task = LoggedEmail.send_email(:new_enquiry, :send_after => Time.now, :send_before => Time.now + 1.hour,  :actor => _user, :act_object => _article, :act_target => _user_t )

    assert _queued_task.persisted?
    #_queued_task.should be_an_instance_of LoggedEmail

  end

  def test_description
    _user    = User.create()
    _article = Article.create()
    _user_t  = User.create()

    _description = "this is a test"
    _queued_task = LoggedEmail.send_email(:test_description, :send_after => Time.now, :send_before => Time.now + 1.hour,   :actor => _user, :act_object => _article, :act_target => _user_t ,
                                 :description => _description )

    assert _queued_task.description  == _description

  end

  def test_options
    _user    = User.create()
    _article = Article.create()
    _user_t  = User.create()

    _country = "denmark"
    _queued_task = LoggedEmail.send_email(:test_option, :send_after => Time.now, :send_before => Time.now + 1.hour, :actor => _user, :act_object => _article, :act_target => _user_t ,
                                 :country => _country )

    assert _queued_task.options[:country]  == _country

  end

  def test_bond_type
    _user    = User.create()
    _article = Article.create()
    _user_t  = User.create()

    _queued_task = LoggedEmail.send_email(:test_bond_type, :send_after => Time.now, :send_before => Time.now + 1.hour, :actor => _user, :act_object => _article, :act_target => _user_t )

    assert _queued_task.bond_type  == 'global'

  end

  def test_poll_changes

    _user    = User.create()
    _article = Article.create()
    _user_t  = User.create()

    _activity = LoggedEmail.send_email(:test_bond_type, :send_after => Time.now - 1.hour, :send_before => Time.now + 1.hour, :actor => _user, :act_object => _article, :act_target => _user_t )

    assert LoggedEmail.all.size > 0


    LoggedEmail.poll_for_changes() do |verb, hash|
      #assert hash[:actor].id == _user.id
    end

    assert LoggedEmail.where('state = ? AND act_target_id = ?', 'initial', _user_t.id).size == 0

  end






end