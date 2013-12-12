# Autocomplete
require 'irb/completion'

# History
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['DOT']}/history/irb"

# copy a string to the clipboard
def pbcopy(string)
  `echo "#{string}" | pbcopy`
  string
end


class Object
	
	# Easily print methods local to an object's class
  def local_methods
    (methods - Object.instance_methods).sort
  end
end
