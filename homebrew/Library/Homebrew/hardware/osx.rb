module Hardware::OSX
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def cpu_type
      @@cpu_type ||= `/usr/sbin/sysctl -n hw.cputype`.to_i

      case @@cpu_type
      when 7
        :intel
      when 18
        :ppc
      else
        :dunno
      end
    end

    def intel_family
      @@intel_family ||= `/usr/sbin/sysctl -n hw.cpufamily`.to_i

      case @@intel_family
      when 0x73d67300 # Yonah: Core Solo/Duo
        :core
      when 0x426f69ef # Merom: Core 2 Duo
        :core2
      when 0x78ea4fbc # Penryn
        :penryn
      when 0x6b5a4cd2 # Nehalem
        :nehalem
      when 0x573B5EEC # Arrandale
        :arrandale
      else
        :dunno
      end
    end

    def processor_count
      @@processor_count ||= `/usr/sbin/sysctl -n hw.ncpu`.to_i
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
      self.sysctl_bool("hw.cpu64bit_capable")
    end
    
    def bits
      Hardware.is_64_bit? ? 64 : 32
    end

  protected
    def sysctl_bool(property)
      result = nil
      IO.popen("/usr/sbin/sysctl -n #{property} 2>/dev/null") do |f|
        result = f.gets.to_i # should be 0 or 1
      end
      $?.success? && result == 1 # sysctl call succeded and printed 1
    end
  end
end
