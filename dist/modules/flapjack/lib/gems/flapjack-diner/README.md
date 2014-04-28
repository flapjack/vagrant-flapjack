# Flapjack::Diner

[![Travis CI Status][id_travis_img]][id_travis_link]

[id_travis_link]: https://secure.travis-ci.org/#!/flpjck/flapjack-diner
[id_travis_img]: https://secure.travis-ci.org/flpjck/flapjack-diner.png

Access the API of a [Flapjack](http://flapjack-project.com/) system monitoring server.

## Installation

Add this line to your application's Gemfile:

    gem 'flapjack-diner', :git => 'git://github.com/flpjck/flapjack-diner.git'

And then execute:

    $ bundle

## Usage

Set the URI of the Flapjack server:

```ruby
Flapjack::Diner.base_uri('127.0.0.1:5000')
```

Optionally, set a logger to log requests & responses:

```ruby
Flapjack::Diner.logger = Logger.new('logs/flapjack_diner.log')
```

## Functions

* [entities](#entities)
* [checks](#checks)
* status ([single check](#status_check) / [all checks](#status) / [bulk](#status_bulk))
* scheduled maintentance periods ([single check](#scheduled_maintenance_check) / [all checks](#scheduled_maintenance) / [bulk](#scheduled_maintenance_bulk))
* unscheduled maintentance periods ([single check](#unscheduled_maintenance_check) / [all checks](#unscheduled_maintenance) / [bulk](#unscheduled_maintenance_bulk))
* outages ([single check](#outages_check) / [all checks](#outages) / [bulk](#outages_bulk))
* downtimes ([single check](#downtimes_check) / [all checks](#downtimes) / [bulk](#downtimes_bulk))
* create scheduled maintenance period ([single check](#create_scheduled_maintenance) / [bulk](#create_scheduled_maintenance_bulk))
* delete scheduled maintenance period ([single check](#delete_scheduled_maintenance) / [bulk](#delete_scheduled_maintenance_bulk))
* acknowledge ([single check](#acknowledge) / [bulk](#acknowledge_bulk))
* delete unscheduled maintenance period ([single check](#delete_unscheduled_maintenance) / [bulk](#delete_unscheduled_maintenance_bulk))
* test notifications ([single check](#test_notifications) / [bulk](#test_notifications_bulk))
* [get entity tags](#get_entity_tags)
* [add entity tags](#add_entity_tags)
* [delete entity tags](#delete_entity_tags)
* [get contact tags](#get_contact_tags)
* [add contact tags](#add_contact_tags)
* [delete contact tags](#delete_contact_tags)
* [get tags for contact's linked entities](#get_contact_entitytags)
* [add tags to contact's linked entities](#add_contact_entitytags)
* [delete tags from contact's linked entities](#delete_contact_entitytags)
* [contacts](#contacts)
* [contact](#contact)
* [notification rules](#notification_rules)
* [notification rule](#notification_rule)
* [create notification rule](#create_notification_rule)
* [update notification rule](#update_notification_rule)
* [delete notification rule](#delete_notification_rule)
* [notification media](#notification_media)
* [notification medium](#notification_medium)
* [update notification medium](#update_notification_medium)
* [delete notification medium](#delete_notification_medium)
* [contact timezone](#contact_timezone)
* [update contact timezone](#update_contact_timezone)
* [delete contact timezone](#delete_contact_timezone)

---

<a name="entities">&nbsp;</a>
Return an array of monitored entities, and their statuses for all associated checks:

```ruby
Flapjack::Diner.entities
```

The data is returned as an array where each element is a hash representing an entity.

```
// ID     is an integer, to hold e.g. database id from an external system
// NAME   is a string
// STATUS is a hash with the format returned from Flapjack::Diner.status(entity, check)
[{'id'     => ID,
  'name'   => NAME,
  'checks' => [STATUS, STATUS, ...]},
 {},
 ...]
```

---

<a name="checks">&nbsp;</a>
Return an array of checks for an entity:

```ruby
Flapjack::Diner.checks('example.com')
```

The data is returned as an array of strings, where each element is a check name for the provided entity.

```
// CHECK is a string, e.g. 'ssh', 'ping'
[CHECK, CHECK, ...]
```

---
<a name="status_check">&nbsp;</a>
Return the status for a check on an entity

```ruby
Flapjack::Diner.status('example.com', :check => 'ping')
```

The data is returned as a hash:

```
// CHECK is a string, e.g. 'ssh', 'ping'
// STATE is a string, one of 'critical', 'warning', 'ok', 'unknown'
// the TIMESTAMPs are integers representing UTC times for the named events
{'name' => CHECK,
 'state' => STATE,
 'in_unscheduled_maintenance' => BOOLEAN,
 'in_scheduled_maintenance' => BOOLEAN,
 'last_update' => TIMESTAMP,
 'last_problem_notification' => TIMESTAMP,
 'last_recovery_notification' => TIMESTAMP,
 'last_acknowledgement_notification' => TIMESTAMP}
 ```

---
<a name="status">&nbsp;</a>
Return the statuses for all checks on an entity

```ruby
Flapjack::Diner.status('example.com')
```

The data is returned as an array of checks, where each element is a hash with the format returned from Flapjack::Diner.status(entity, check)

```
// STATUS is a hash with the format returned from Flapjack::Diner.status(entity, check)
[STATUS, STATUS, ...]
```

---
<a name="status_bulk">&nbsp;</a>
Return the statuses for all checks on some entities and specified checks on others.

```ruby
# :entity - optional, may be a String or an Array of Strings (entity names)
# :check  - optional, Hash, keys are Strings (entity names), values are Strings or Arrays of Strings (check names)
# At least one of the :entity or :check arguments must be provided
Flapjack::Diner.bulk_status(:entity => 'example.com',
                            :check => {'example2.com' => ['PING', 'SSH'],
                                       'example3.com' => 'PING'})
```

The data is returned as an array, where each element is a hash with the format

```
// ENTITY is a string, one of the entity names provided in the entity or check arguments.
// CHECK is a string, e.g. 'ssh', 'ping'
// STATUS is a hash with the format returned from Flapjack::Diner.status(entity, check)
{'entity' => ENTITY
 'check'  => CHECK,
 'status' => STATUS}
```

---
<a name="scheduled_maintenance_check">&nbsp;</a>
Return an array of scheduled maintenance periods for a check on an entity:

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.scheduled_maintenances('example.com', :check => 'ping',
                                       :start_time => Time.local(2012, 08, 01),
                                       :end_time => Time.local(2012, 09, 01))
```

The data is returned as an array of scheduled maintenance periods, with each element of the array being a hash containing data about that maintenance period.

```
// the TIMESTAMPs are integers representing UTC times for the named events
// DURATION is an integer representing the length of the period in seconds
// SUMMARY is a string providing a description of the period, may be empty
[{'start_time' => TIMESTAMP,
  'duration' => DURATION,
  'summary' => SUMMARY,
  'end_time' => TIMESTAMP},
  {...},
  ...]
```

---
<a name="scheduled_maintenance">&nbsp;</a>
Return lists of scheduled maintenance periods for all checks on an entity:

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.scheduled_maintenances('example.com',
                                       :start_time => Time.local(2012, 08, 01),
                                       :end_time => Time.local(2012, 09, 01))
```

The data is returned as an array of hashes, where each hash represents the scheduled maintenance periods for a check under the entity :

```
// CHECK is a string, e.g. 'ssh', 'ping'
// SCHED_MAINT is a hash with the same format as an individual element of
//   the array returned from Flapjack::Diner.scheduled_maintenances(entity, check)
[{'check' => CHECK,
  'scheduled_maintenance' => [SCHED_MAINT, ...]
 },
 {'check' => CHECK,
  'scheduled_maintenance' => [SCHED_MAINT, ...]
 }]
```

---
<a name="scheduled_maintenance_bulk">&nbsp;</a>
Return lists of scheduled maintenance periods for all checks on some entities and specified checks on others.

```ruby
# :entity - optional, may be a String or an Array of Strings (entity names)
# :check  - optional, Hash, keys are Strings (entity names), values are Strings
#             or Arrays of Strings (check names)
# At least one of the :entity or :check arguments must be provided
Flapjack::Diner.bulk_scheduled_maintenances(:entity => 'example.com',
                                            :check => {'example2.com' => ['PING', 'SSH'],
                                                       'example3.com' => 'PING'})
```

The data is returned as an array, where each element is a hash with the format

```
// ENTITY is a string, one of the entity names provided in the entity or check arguments
// CHECK is a string, e.g. 'ssh', 'ping'
// SCHED_MAINT is a hash with the same format as an individual element of the array returned from Flapjack::Diner.scheduled_maintenances(entity, check)
{'entity' => ENTITY
 'check'  => CHECK,
 'scheduled_maintenances' => [SCHED_MAINT, ...]}
```

Please note the plural for the 'scheduled_maintenances' hash key, which is different to
the other methods.

---
<a name="unscheduled_maintenance_check">&nbsp;</a>
Return an array of unscheduled maintenance periods for a check on an entity:

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.unscheduled_maintenances('example.com', :check => 'ping',
                                         :start_time => Time.local(2012, 08, 01),
                                         :end_time => Time.local(2012, 09, 01))
```

The data is returned as an array of unscheduled maintenance periods, with each element of the array being a hash containing data about that maintenance period.

```
// the TIMESTAMPs are integers representing UTC times for the named events
// DURATION is an integer representing the length of the period in seconds
// SUMMARY is a string providing a description of the period, may be empty
[{'start_time' => TIMESTAMP,
  'duration' => DURATION,
  'summary' => SUMMARY,
  'end_time' => TIMESTAMP},
  {...},
  ...]
```

---
<a name="unscheduled_maintenance">&nbsp;</a>
Return lists of unscheduled maintenance periods for all checks on an entity:

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.unscheduled_maintenances('example.com',
                                         :start_time => Time.local(2012, 08, 01),
                                         :end_time => Time.local(2012, 09, 01))
```

The data is returned as an array of hashes, where each hash represents the unscheduled maintenance periods for a check under the entity:

```
// CHECK is a string, e.g. 'ssh', 'ping'
// UNSCHED_MAINT is a hash with the same format as an individual element of
//   the array returned from Flapjack::Diner.unscheduled_maintenances(entity, check)
[{'check' => CHECK,
  'unscheduled_maintenance' => [UNSCHED_MAINT, ...]
 },
 {'check' => CHECK,
  'unscheduled_maintenance' => [UNSCHED_MAINT, ...]
 }]
```

---
<a name="unscheduled_maintenance_bulk">&nbsp;</a>
Return lists of unscheduled maintenance periods for all checks on some entities and specified checks on others.

```ruby
# :entity - optional, may be a String or an Array of Strings (entity names)
# :check  - optional, Hash, keys are Strings (entity names), values are Strings
#             or Arrays of Strings (check names)
# At least one of the :entity or :check arguments must be provided
Flapjack::Diner.bulk_unscheduled_maintenances(:entity => 'example.com',
                                              :check => {'example2.com' => ['PING', 'SSH'],
                                                         'example3.com' => 'PING'})
```

The data is returned as an array, where each element is a hash with the format

```
// ENTITY is a string, one of the entity names provided in the entity or check arguments
// CHECK is a string, e.g. 'ssh', 'ping'
// UNSCHED_MAINT is a hash with the same format as an individual element of the
//   array returned from Flapjack::Diner.unscheduled_maintenances(entity, check)
{'entity' => ENTITY
 'check'  => CHECK,
 'unscheduled_maintenances' => [UNSCHED_MAINT, ...]
}
```

Please note the plural for the 'unscheduled_maintenances' hash key, which is different to
the other methods.

---
<a name="outages_check">&nbsp;</a>
Return an array of outages for a check on an entity (all times for which the check was failing):

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.outages('example.com', :check => 'ping',
                        :start_time => Time.local(2012, 08, 01),
                        :end_time => Time.local(2012, 09, 01))
```

The data is returned as an array of outage periods, with each element of the array being a hash containing data about that outage period.

```
// STATE is a string, one of 'critical', 'warning', 'ok', 'unknown'
// the TIMESTAMPs are integers representing UTC times for the named events
// SUMMARY is a string providing a description of the period, may be empty
[{'state' => STATE,
  'start_time' => TIMESTAMP,
  'end_time' => TIMESTAMP,
  'summary' => SUMMARY},
  {...},
  ...]
```

---
<a name="outages">&nbsp;</a>
Return lists of outages for all checks on an entity (all times for which said checks were failing):

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.outages('example.com', :start_time => Time.local(2012, 08, 01),
                                       :end_time => Time.local(2012, 09, 01))
```

The data is returned as an array of hashes, where each hash represents the outages for a check under the entity:

```
// CHECK is a string, e.g. 'ssh', 'ping'
// OUTAGE is a hash with the same format as an individual element of the array returned from Flapjack::Diner.outages(entity, check)
[{'check' => CHECK,
  'outages' => [OUTAGE, ...]
 },
 {'check' => CHECK,
  'outages' => [OUTAGE, ...]
 }]
```

---
<a name="outages_bulk">&nbsp;</a>
Return lists of outages for all checks on some entities and specified checks on others.

```ruby
# :entity - optional, may be a String or an Array of Strings (entity names)
# :check  - optional, Hash, keys are Strings (entity names), values are Strings
#             or Arrays of Strings (check names)
# At least one of the :entity or :check arguments must be provided
Flapjack::Diner.bulk_outages(:entity => 'example.com',
                             :check => {'example2.com' => ['PING', 'SSH'],
                                        'example3.com' => 'PING'})
```

The data is returned as an array, where each element is a hash with the format

```
// ENTITY is a string, one of the entity names provided in the entity or check arguments
// CHECK is a string, e.g. 'ssh', 'ping'
// OUTAGE is a hash with the same format as an individual element of the array
//   returned from Flapjack::Diner.outages(entity, check)
{'entity' => ENTITY
 'check'  => CHECK,
 'outages' => [OUTAGE, ...]
}
```

---
<a name="downtimes_check">&nbsp;</a>
Return an array of downtimes for a check on an entity (outages outside of scheduled maintenance periods):

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.downtime('example.com', :check => 'ping',
                         :start_time => Time.local(2012, 08, 01),
                         :end_time => Time.local(2012, 09, 01))
```

Returns a hash with some statistics about the downtimes, including an array of the downtimes themselves. This may not be the same as would be returned from the 'outages' call for the same time period, as if scheduled maintenance periods overlap any of those times then they will be reduced, split or discarded to fit.

```
// TOTAL SECONDS gives the sum of the time spent in that state for each check state.
// PERCENTAGES represents the proportion of the total time that the check was
//   in each state. Will be null if either start or end time were not provided
//   in the request.
// OUTAGE is a hash with the same format as an individual element of the array
//   returned from Flapjack::Diner.outages(entity, check).
{'total_seconds' => {STATE => INTEGER, ...},
 'percentages' => {STATE => INTEGER, ...},
 'downtime' => [OUTAGE, ...]
}
```

---
<a name="downtimes">&nbsp;</a>
Return an array of downtimes for all checks on an entity (outages outside of scheduled maintenance periods):

```ruby
# start time (Time object, optional)
# end time (Time object, optional)
Flapjack::Diner.downtime('example.com', :start_time => Time.local(2012, 08, 01),
                         :end_time => Time.local(2012, 09, 01))
```

The data is returned as an array of hashes, where each hash represents a downtime report for a check under the entity:

```
// CHECK is a string, e.g. 'ssh', 'ping'
// DOWNTIME is a hash with the same format those returned from
//   Flapjack::Diner.downtime(entity, check)
[{'check' => CHECK,
  'downtime' => [DOWNTIME, ...]
 },
 {'check' => CHECK,
  'downtime' => [DOWNTIME, ...]
 }]
```

---
<a name="downtimes_bulk">&nbsp;</a>

Return lists of downtimes for all checks on some entities and specified checks on others.

```ruby
# :entity - optional, may be a String or an Array of Strings (entity names)
# :check  - optional, Hash, keys are Strings (entity names), values are Strings
#             or Arrays of Strings (check names)
# At least one of the :entity or :check arguments must be provided
Flapjack::Diner.bulk_downtime(:entity => ['example.com', 'example4.com'],
                              :check => {'example2.com' => ['PING', 'SSH'],
                                         'example3.com' => 'PING'})
```

The data is returned as an array, where each element is a hash with the format

```
// ENTITY is a string, one of the entity names provided in the entity or check arguments
// CHECK is a string, e.g. 'ssh', 'ping'
// DOWNTIME is a hash with the same format as an individual element of the array
//   returned from Flapjack::Diner.downtime(entity, check)
{'entity' => ENTITY
 'check'  => CHECK,
 'downtime' => [DOWNTIME, ...]
}
```

---
<a name="create_scheduled_maintenance">&nbsp;</a>
Create a scheduled maintenance period for a check on an entity:

```ruby
# start_time (Time object, required)
# duration (Integer, required) is measured in seconds
# summary (String, optional)
Flapjack::Diner.create_scheduled_maintenance!('example.com', 'ping',
  :start_time => Time.local(2012, 12, 01), :duration => (60 * 60),
  :summary => 'changing stuff')
```

Returns a boolean value representing the success or otherwise of the creation of the scheduled maintenance period by the server.

---
<a name="create_scheduled_maintenance_bulk">&nbsp;</a>
Create scheduled maintenance periods for all checks on some entities and specified checks on others.

```ruby
# start_time (Time object, required)
# duration (Integer, required) is measured in seconds
# summary (String, optional)
Flapjack::Diner.bulk_create_scheduled_maintenance!(:entity => ['example.com', 'example2.com'],
  :check => {'example3.com' => 'ping'}, :start_time => Time.local(2012, 12, 01),
  :duration => (60 * 60), :summary => 'changing stuff')
```

Returns a boolean value representing the success or otherwise of the creation of the scheduled maintenance periods by the server.

---
<a name="delete_scheduled_maintenance">&nbsp;</a>
Delete a scheduled maintenance period for a check on an entity:

```ruby
# start_time (Time object, required)
Flapjack::Diner.delete_scheduled_maintenance!('example.com', 'ping',
  :start_time => Time.local(2012, 12, 01))
```

Returns a boolean value representing the success or otherwise of the deletion of the scheduled maintenance periods by the server.

---
<a name="delete_scheduled_maintenance_bulk">&nbsp;</a>
Delete a scheduled maintenance period for all checks on some entities and specified checks on others.

```ruby
# start_time (Time object, required)
Flapjack::Diner.bulk_delete_scheduled_maintenance!(:check => {'example.com' => ['ping', 'ssh']},
  :start_time => Time.local(2012, 12, 01))
```

Returns a boolean value representing the success or otherwise of the deletion of the scheduled maintenance periods by the server.

---
<a name="acknowledge">&nbsp;</a>
Acknowledge the current state for a check on an entity:

```ruby
# summary (String, optional)
Flapjack::Diner.acknowledge!('example.com', 'ping', :summary => 'ack')
```

Returns a boolean value representing the success or otherwise of the creation of the acknowledgement by the server.

---
<a name="acknowledge_bulk">&nbsp;</a>
Acknowledge the current state for all checks on some entities and specified checks on others.

```ruby
# summary (String, optional)
Flapjack::Diner.bulk_acknowledge!(:entity => 'example.com',
  :check => {'example2.com' => 'ping'}, :summary => 'ack')
```

Returns a boolean value representing the success or otherwise of the creation of the acknowledgements by the server.

---
<a name="delete_unscheduled_maintenance">&nbsp;</a>
Delete an unscheduled maintenance period for a check on an entity:

```ruby
# end_time (Time object, optional)
Flapjack::Diner.delete_unscheduled_maintenance!('example.com', 'ping',
  :end_time => Time.local(2012, 12, 01))
```

Returns a boolean value representing the success or otherwise of the deletion of the scheduled maintenance periods by the server.

---
<a name="delete_unscheduled_maintenance_bulk">&nbsp;</a>
Delete unscheduled maintenance periods for all checks on some entities and specified checks on others.

```ruby
# end_time (Time object, optional)
Flapjack::Diner.bulk_delete_unscheduled_maintenance!(:check => {'example.com' => ['ping', 'ssh']},
  :end_time => Time.local(2012, 12, 01))
```

Returns a boolean value representing the success or otherwise of the deletion of the scheduled maintenance periods by the server.

---
<a name="test_notifications">&nbsp;</a>
Generate test notifications for a check on an entity:

```ruby
# summary (String, optional)
Flapjack::Diner.test_notifications!('example.com', 'HOST',
  :summary => 'Testing notifications to all contacts interested in the HOST check on example.com')
```

Returns a boolean value representing the success or otherwise of the creation of the notifications by the server.

---
<a name="test_notifications_bulk">&nbsp;</a>
Generate test notifications for all checks on some entities and specified checks on others.

```ruby
# summary (String, optional)
Flapjack::Diner.bulk_test_notifications!(:entity => 'example.com',
  :check => {'example2.com' => 'ping'}, :summary => 'Testing notifications')
```

Returns a boolean value representing the success or otherwise of the creation of the notifications by the server.

---
<a name="get_entity_tags">&nbsp;</a>
Get all tags for an entity.

```ruby
# entity name (String, required)
Flapjack::Diner.entity_tags('example.com')
```

The data is returned as an array of strings; each string is a named tag set on the entity. The array may be empty.

---
<a name="add_entity_tags">&nbsp;</a>
Add one or more tags to an entity.

```ruby
# entity name (String, required)
# *tags (at least one String)
Flapjack::Diner.add_entity_tags!('example.com', 'tag1', 'tag2')
```

The data is returned as an array of strings; each string is a named tag set on the entity. The array will, at a minimum, contain the tag(s) added by the request.

---
<a name="delete_entity tags">&nbsp;</a>
Delete one or more tags from an entity.

```ruby
# entity name (String, required)
# *tags (at least one String)
Flapjack::Diner.delete_entity_tags!('example.com', 'tag1')
```

Returns a boolean representing the success (or otherwise) of the tag deletion.

---
<a name="get_contact_tags">&nbsp;</a>
Get all tags for a contact.

```ruby
# contact ID (String, required)
Flapjack::Diner.contact_tags('21')
```

The data is returned as an array of strings; each string is a named tag set on the contact. The array may be empty.

---
<a name="add_contact_tags">&nbsp;</a>
Add one or more tags to a contact.

```ruby
# contact ID (String, required)
# *tags (at least one String)
Flapjack::Diner.add_contact_tags!('21', 'tag1', 'tag2')
```

The data is returned as an array of strings; each string is a named tag set on the contact. The array will, at a minimum, contain the tag(s) added by the request.

---
<a name="delete_contact_tags">&nbsp;</a>
Delete one or more tags from a contact.

```ruby
# contact ID (String, required)
# *tags (at least one String)
Flapjack::Diner.delete_contact_tags!('21', 'tag1')
```

Returns a boolean representing the success (or otherwise) of the tag deletion.

---
<a name="get_contact_entitytags">&nbsp;</a>
Get all tags for entities linked to a contact.

```ruby
# contact ID (String, required)
Flapjack::Diner.contact_entitytags('21')
```

The data is returned as a Hash, with String keys representing entity names, and Arrays of String values representing the tags for each named entity.

```
{
  ENTITY => [TAG, ...],
  ENTITY => [TAG, ...],
  ...
}
```

---
<a name="add_contact_entitytags">&nbsp;</a>
Add one or more tags to entities linked to a contact.

```ruby
# contact ID (String, required)
# entity_tags (Hash, required - similar format as returned by 'contact_entitytags')
Flapjack::Diner.add_contact_entitytags!('21', {'entity1' => ['web'], 'entity2' => ['app']})
```

The data is returned as a Hash, reflecting the current tags for the contact's linked entities. This is in the same format as the ```contact_entitytags``` call returns.

---
<a name="delete_contact_entitytags">&nbsp;</a>
Delete one or more tags from entities linked to a contact.

```ruby
# contact ID (String, required)
# entity_tags (Hash, required - similar format as returned by 'contact_entitytags')
Flapjack::Diner.add_contact_entitytags!('21', {'entity1' => ['web'], 'entity2' => ['app']})
```

Returns a boolean representing the success (or otherwise) of the tag deletion.

---
<a name="contacts">&nbsp;</a>
Gets all contact records.

```ruby
Flapjack::Diner.contacts
```

The data is returned as an array of hashes, where each hash represents a contact. The tags array will be empty if the associated contact has no tags.

```ruby
[
  {
    'id' => STRING,
    'first_name' => STRING,
    'last_name' => STRING,
    'email' => STRING,
    'tags' => [STRING, ...]
  },
  ...
]
```

---
<a name="contact">&nbsp;</a>
Get a single contact record.

```ruby
# contact_id (String, required)
Flapjack::Diner.contact('contact23')
```

The contact record is returned as a hash (a singular instance of what is returned in the full contact list). The tags array will be empty if the contact has no tags

```ruby
{
  'id' => STRING,
  'first_name' => STRING,
  'last_name' => STRING,
  'email' => STRING,
  'tags' => [STRING, ...]
}
```

---
<a name="notification_rules">&nbsp;</a>
Gets the notification rules belonging to a contact.

```ruby
# contact_id (String, required)
Flapjack::Diner.notification_rules('contact23')
```

Returns an array of hashes, where a single hash represents a notification rule record. NB 'time_restrictions' have not yet been implemented, but we're noting the use of the field name here as it will be meaningful in the future.

```ruby
# contact_id (String, as provided in the request)
# rule_id (String, allocated on creation, immutable)
[
  {
    'id' => RULE_ID,
    'contact_id' => CONTACT_ID,
    'entity_tags' => [STRING, ...]
    'entities' => [STRING, ...],
    'time_restrictions' => [],
    'warning_media' => [STRING, ...],
    'critical_media' => [STRING, ...],
    'warning_blackhole' => BOOLEAN,
    'critical_blackhole' => BOOLEAN
  },
  ...
]
```

---
<a name="notification_rule">&nbsp;</a>
Gets a single notification rule belonging to a contact.

```ruby
# rule_id (String, required)
Flapjack::Diner.notification_rule('08f607c7-618d-460a-b3fe-868464eb6045')
```

Returns a hash representing a notification rule record (a singular instance of what is returned in a list of a contact's notification rules). NB 'time_restrictions' have not yet been implemented, but we're noting the use of the field name here as it will be meaningful in the future.

```ruby
# RULE_ID (String, as provided in the request)
# CONTACT_ID (String)
{
  'id' => RULE_ID,
  'contact_id' => CONTACT_ID,
  'entity_tags' => [STRING, ...]
  'entities' => [STRING, ...],
  'time_restrictions' => [],
  'warning_media' => [STRING, ...],
  'critical_media' => [STRING, ...],
  'warning_blackhole' => BOOLEAN,
  'critical_blackhole' => BOOLEAN
}
```

---
<a name="create_notification_rule">&nbsp;</a>
Creates a notification rule for a contact.

```ruby
# rule_data (Hash, will be converted via to_json)
#   contact_id (String, required)
#   entity_tags (Array of Strings, may be empty; either this or 'entities' must have some content)
#   entities (Array of Strings, may be empty; either this or 'entity_tags' must have some content)
#   time_restrictions (TBD)
#   warning_media (Array of Strings, may be empty; each represents a media type)
#   critical_media (Array of Strings, may be empty; each represents a media type)
#   warning_blackhole (Boolean, required)
#   critical_blackhole (Boolean, required)
Flapjack::Diner.create_notification_rule!({
  'contact_id' => 'contact23',
  'entity_tags' => ['database'],
  'entities' => ['app-1.example.com']
  'time_restrictions' => [],
  'warning_media' => ['email'],
  'critical_media' => ['email', 'sms'],
  'warning_blackhole' => false,
  'critical_blackhole' => false
}
})
```

Returns a hash represeting the created notification rule. This is the same data you would receive from ```Flapjack::Diner.notification_rule(rule_id)```.

```ruby
# RULE_ID (String, as provided in the request)
# CONTACT_ID (String)
{
  'id' => RULE_ID,
  'contact_id' => CONTACT_ID,
  'entity_tags' => [STRING, ...]
  'entities' => [STRING, ...],
  'time_restrictions' => [],
  'warning_media' => [STRING, ...],
  'critical_media' => [STRING, ...],
  'warning_blackhole' => BOOLEAN,
  'critical_blackhole' => BOOLEAN
}
```

---
<a name="update_notification_rule">&nbsp;</a>
Updates a notification rule for a contact.

```ruby
# rule_id (String, required)
# rule_data (Hash, will be converted via to_json)
#   contact_id (String, required)
#   entity_tags (Array of Strings, may be empty; either this or 'entities' must have some content)
#   entities (Array of Strings, may be empty; either this or 'entity_tags' must have some content)
#   time_restrictions (TBD)
#   warning_media (Array of Strings, may be empty; each represents a media type)
#   critical_media (Array of Strings, may be empty; each represents a media type)
#   warning_blackhole (Boolean, required)
#   critical_blackhole (Boolean, required)
Flapjack::Diner.update_notification_rule!('08f607c7-618d-460a-b3fe-868464eb6045', {
  'contact_id' => 'contact23',
  'entity_tags' => ['database'],
  'entities' => ['app-1.example.com']
  'time_restrictions' => [],
  'warning_media' => ['email'],
  'critical_media' => ['email', 'sms'],
  'warning_blackhole' => false,
  'critical_blackhole' => false
})
```

Returns a hash represeting the updated notification rule. This is the same data you would receive from ```Flapjack::Diner.notification_rule(rule_id)```.

```ruby
# RULE_ID (String, as provided in the request)
# CONTACT_ID (String)
{
  'id' => RULE_ID,
  'contact_id' => CONTACT_ID,
  'entity_tags' => [STRING, ...]
  'entities' => [STRING, ...],
  'time_restrictions' => [],
  'warning_media' => [STRING, ...],
  'critical_media' => [STRING, ...],
  'warning_blackhole' => BOOLEAN,
  'critical_blackhole' => BOOLEAN
}
```

---
<a name="delete_notification_rule">&nbsp;</a>
Deletes a notification rule from a contact.

```ruby
# rule_id (String, required)
Flapjack::Diner.delete_notification_rule!('08f607c7-618d-460a-b3fe-868464eb6045')
```

Returns a boolean value representing the success or otherwise of the deletion of the notification rule.

---
<a name="notification_media">&nbsp;</a>
Return a list of a contact's notification media values.

```ruby
# contact_id (String, required)
Flapjack::Diner.contact_media('contact23')
```

Returns a hash of hashes, where the first layer of keys are the media types (e.g. 'email', 'sms') and the
hashes for each of those media type keys contain address and notification interval values.

```ruby
# interval (Integer, in seconds - notifications will not be sent more often than this through this medium)
{
  MEDIA_TYPE => { 'address' => STRING,
                  'interval' => INTEGER },
  ...
}
```

---
<a name="notification_medium">&nbsp;</a>
Get the values for a contact's notification medium.

```ruby
# contact_id (String, required)
# media_type (String, required)
Flapjack::Diner.contact_medium('contact23', 'sms')
```

Returns a hash corresponding to a single hash of medium values from those returned by ```Flapjack::Diner.contact_media()```.

```ruby
# interval (Integer, in seconds - notifications will not be sent more often than this through this medium)
{ 'address' => STRING,
  'interval' => INTEGER },
```

---
<a name="update_notification_medium">&nbsp;</a>
Update the values for a contact's notification medium.

```ruby
# contact_id (String, required)
# media_type (String, required)
Flapjack::Diner.update_contact_medium!('contact23', 'email', {
  'address' => 'example@example.com',
  'interval' => 300
})
```

Returns the hash that was submitted.

```ruby
# interval (Integer, in seconds - notifications will not be sent more often than this through this medium)
{ 'address' => STRING,
  'interval' => INTEGER },
```

---
<a name="delete_notification_medium">&nbsp;</a>
Delete a contact's notification medium.

```ruby
# contact_id (String, required)
# media_type (String, required)
Flapjack::Diner.delete_contact_medium!('contact23', 'sms')
```

Returns a boolean value representing the success or otherwise of the deletion of the notification medium values.

---
<a name="contact_timezone">&nbsp;</a>
Get a contact's timezone.

```ruby
# contact_id (String, required)
Flapjack::Diner.contact_timezone('contact23')
```

Returns a timezone string, as defined in the [timezone database](http://www.twinsun.com/tz/tz-link.htm).

```ruby
'Australia/Perth'
```

---
<a name="update_contact_timezone">&nbsp;</a>
Update a contact's timezone.

```ruby
# contact_id (String, required)
# timezone (String, required)
Flapjack::Diner.update_contact_timezone!('contact23', 'Australia/Sydney')
```

Returns the timezone string provided as a parameter.

```ruby
'Australia/Sydney'
```

---
<a name="delete_contact_timezone">&nbsp;</a>
Delete a contact's timezone. (If a contact's timezone is unknown they will be assumed to share the Flapjack server's timezone.)

```ruby
# contact_id (String, required)
Flapjack::Diner.delete_contact_timezone!('contact_23')
```

Returns a boolean value representing the success or otherwise of the deletion of the contact's timezone.

---

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
