puts "Ruby #{RUBY_VERSION}"
puts "`loadext` for some gems"

# IRB extensions
require 'irb/completion'
require 'irb/ext/save-history'

def loadext
  reqs = %w[
    rubygems
    fileutils
    ostruct
    ap
  ]

  loaded_reqs = []
  errored_reqs = []

  reqs.each do |req|
    begin
      require req
      loaded_reqs.push req
    rescue LoadError
      errored_reqs.push req
    end
  end

  message = "Loaded: #{loaded_reqs.join(', ')}"
  message << "   |   Problem loading: #{errored_reqs.join(', ')}" if errored_reqs.size > 0
  message
end

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['DOT']}/history/irb"
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:IGNORE_SIGINT] = false

# copy a string to the clipboard
def copy(string)
  IO.popen('pbcopy', 'w') { |f| f << string.to_s }
  string
end

def paste
  `pbpaste`
end

# d'oh
alias :exti :exit
alias :ext :exit

class Object
  # Easily print methods local to an object's class
  def local_methods
    (methods - Object.instance_methods).sort
  end

  def inspect
    ap self
  end
end

class String
  def |(cmd)
    IO.popen(cmd.to_s, 'r+') do |pipe|
      pipe.write(self)
      pipe.close_write
      pipe.read
    end
  end
end

