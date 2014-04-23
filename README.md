# Barber [![Build Status](https://travis-ci.org/tchak/barber.png)](https://travis-ci.org/tchak/barber)

Barber handles all your Handlebars precompilation needs. You can use
Barber as part of your project build system or with someting like
[rake-pipeline](https://github.com/livingsocial/rake-pipeline).

## Installation

Add this line to your application's Gemfile:

    gem 'barber'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install barber

## Usage

You will mainly interact with the utility classes. The utitlity classes
delegate to the actual precompiler. They support two primary use cases:

1. Precompiling individual handlebars files.
2. Precompiling inline handlebars templates.

Here are some code examples:

```ruby
require 'barber'

Barber::FilePrecompiler.call(File.read("template.handlebars"))
# "Handlebars.template(function(...));"

Barber::InlinePrecompiler.call(File.read("template.handlebars"))
# Note the missing semicolon. You can use this with gsub to replace
# calls to inline templates
# "Handlebars.template(function(...))"
```

Barber also packages Ember precompilers. 

```ruby
require 'barber'

Barber::Ember::FilePrecompiler.call(File.read("template.handlebars"))
# "Ember.Handlebars.template(function(...));"

Barber::Ember::InlinePrecompiler.call(File.read("template.handlebars"))
# "Ember.Handlebars.template(function(...))"
```

## Building Custom Precompilers

All of Barber's utility classes (demoed above) delegate to
`Barber::Precompiler`. `Barber::Precompiler` implements a simple public
interface you can use to to build your own. A precompiler simply exposes
a `Barber.precompile` JS property. Override
`Barber::Precompiler#sources` to setup your own. Source must respond to
`#read`. Here is an example:

```ruby
require 'barber'
require 'stringio'

class CustomPrecompiler < Barber::Precompiler
  def sources
    [StringIO.new(custom_compiler)]
  end

  def custom_compiler
    %Q[var Barber = { precompile: function(template) { return "Hello World!" } };]
  end
end
```

## Usage with rake-pipeline-web-filters

All the utility classes implement `call`. This means they can be
subsituted for procs/lambda where needed. Here's how you can get
precompilation of your ember templates with rake-pipeline-web-filters:

```ruby
require 'barber'

match "**/*.handlebars" do
  handlebars :wrapper_proc => Barber::Ember::FilePrecompiler
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
