# MailControl

MailControl is a simple gem for giving both your app and users control over when, if and how emails are sent out.

This gem is inspired by Streama by Christopher Pappas.

[![Build Status](https://secure.travis-ci.org/digitalplaywright/mail-control.png)](http://travis-ci.org/digitalplaywright/mail-control) [![Dependency Status](https://gemnasium.com/digitalplaywright/mail-control.png)](https://gemnasium.com/digitalplaywright/mail-control) [![Code Climate](https://codeclimate.com/github/digitalplaywright/mail-control.png)](https://codeclimate.com/github/digitalplaywright/mail-control)


## Install

    gem install mail-control

## Usage

### Create migration for logged_emails and migrate the database (in your Rails project):

```ruby
rails g mail_control:migration
rake db:migrate
```

### Define Queued Task

Create an LoggedEmail model and define the logged_emails and the fields you would like to cache within the mailing.

An mailing consists of an actor, a verb, an act_object, and a target.

``` ruby
class LoggedEmail < ActiveRecord::Base
  include MailControl::LoggedEmail

  mailing :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :Volume
  end
end
```

The mailing verb is implied from the mailing name, in the above example the verb is :new_enquiry

The act_object may be the entity performing the mailing, or the entity on which the mailing was performed.
e.g John(actor) shared a video(act_object)

The target is the act_object that the verb is enacted on.
e.g. Geraldine(actor) posted a photo(act_object) to her album(target)

This is based on the LoggedEmail Streams 1.0 specification (http://logged_emailstrea.ms)

### Setup Actors

Include the Actor module in a class and override the default followers method.

``` ruby
class User < ActiveRecord::Base
  include MailControl::Actor

end
```



### Publishing LoggedEmail

In your controller or background worker:

``` ruby
current_user.send_email(:new_enquiry, :act_object => @enquiry, :target => @listing)
```
  
This will publish the mailing to the mongoid act_objects returned by the #followers method in the Actor.


## Retrieving LoggedEmail

To retrieve all mailing for an actor

``` ruby
current_user.logged_emails
```
  
To retrieve and filter to a particular mailing type

``` ruby
current_user.logged_emails(:verb => 'new_enquiry')
```

#### Options

Additional options can be required:

``` ruby
class LoggedEmail < ActiveRecord::Base
  include MailControl::LoggedEmail

  mailing :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :Volume
    option       :country
    option       :city
  end
end
```

The option fields are stored using the ActiveRecord 'store' feature.


#### Bond type

A verb can have one bond type. This bond type can be used to classify and quickly retrieve
mailing feed items that belong to a particular aggregate feed, like e.g the global feed.

``` ruby
class LoggedEmail < ActiveRecord::Base
  include MailControl::LoggedEmail

  mailing :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :Volume
    bond_type    :global
  end
end
```

### Poll for changes and empty queue

There is a poll changes interface that will group tasks by first actor and then verb. 

```ruby
LoggedEmail.poll_for_changes() do |verb, hash|
  #verb is the verb the changes are group by
  #hash has format: {:actor          => _actor /* actor is the  */, 
  #                  :act_objects    => act_objects    /* all objects from matching tasks */, 
  #                  :act_object_ids => act_object_ids /* all object ids from matching tasks */,
  #                  :act_targets    => act_targets /* all targets from  matching tasks */ , 
  #                  :act_target_ids => act_target_ids /* all target ids from matching tasks}
end
```




