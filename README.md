# Mongoid Sequence

Mongoid Sequence allows you to specify fields to behave like a sequence number (exactly like the "id" column in conventional SQL flavors).

## Credits

This gem was inspired by a couple of gists by [masatomo](https://gist.github.com/730677) and [ShogunPanda](https://gist.github.com/1086265).

## Usage

Include `Mongoid::Sequence` in your class and call `sequence(:field)`.

Like this:

```ruby
class Sequenced
	include Mongoid::Document
	include Mongoid::Sequence
	
	field :my_sequence, :type => Integer
	sequence :my_sequence
end

s1 = Sequenced.create
s1.sequence #=> 1

s2 = Sequenced.create
s2.sequence #=> 2 # and so on
```

It is possible to add an additional discriminator to the sequence (e.g. a tenant id)
```ruby
class Sequenced
	include Mongoid::Document
	include Mongoid::Sequence

  	field :my_sequence, :type => Integer
  	belongs_to :organization

	sequence :my_sequence, :organization_id
end
```

## Consistency

Mongoid::Sequence uses the atomic [findAndModify](http://www.mongodb.org/display/DOCS/findAndModify+Command) command, so you shouldn't have to worry about the sequence's consistency.

## Installation

Just add it to your projects' `Gemfile`:

```ruby
gem "mongoid-sequence"
```

<hr/>

## Changelog

# 0.4.1
* `dup` now reset the sequence fields, allowing a new value to be created

# 0.4
* Calling the `set_sequence` creation callback only if the sequence has not already been generated.
This permits to `set_sequence` a new record before persisting it.
* Removed the sequence on `id` as it was buggy on mongoid 4

Copyright © 2010 Gonçalo Silva, released under the MIT license
