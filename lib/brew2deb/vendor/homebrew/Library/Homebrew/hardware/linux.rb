module Hardware::Linux

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def cpu_type
      # assume x86/x64 intel/amd.
      :intel
    end

    def intel_family
      @@cpuinfo = `cat /proc/cpuinfo`

      case @@cpuinfo
      when /model name *: Intel.*Core.*i[357] CPU/
        :arrandale
      #when 0x73d67300 # Yonah: Core Solo/Duo
        #:core
      #when 0x426f69ef # Merom: Core 2 Duo
        #:core2
      #when 0x78ea4fbc # Penryn
        #:penryn
      #when 0x6b5a4cd2 # Nehalem
        #:nehalem
      #when 0x573B5EEC # Arrandale
        #:arrandale
      else
        :dunno
      end
    end

    def processor_count
      @@processor_count ||= `cat /proc/cpuinfo`.split("\n").grep(/core id/).uniq.size
    end
    
    def cores_as_words
      case Hardware.processor_count
      when 1 then 'single'
      when 2 then 'dual'
      when 4 then 'quad'
      else
        Hardware.processor_count
      end
    end

    def is_32_bit?
      not self.is_64_bit?
    end

    def is_64_bit?
      @@uname_m ||= `uname -m`.chomp
      case @@uname_m
      when "x86_64"
        true
      else
        false
      end
    end
    
    def bits
      Hardware.is_64_bit? ? 64 : 32
    end
  end
end
