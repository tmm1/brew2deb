class Hardware
  # These methods use info spewed out by sysctl.
  # Look in <mach/machine.h> for decoding info.
  
  if RUBY_PLATFORM =~ /-linux$/
    require "hardware/linux"
    include Hardware::Linux
  else
    require "hardware/osx"
    include Hardware::OSX
  end
end
