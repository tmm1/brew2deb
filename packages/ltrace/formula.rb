class Ltrace < DebianFormula
  homepage 'http://ltrace.org/'
  url 'git://git.debian.org/git/collab-maint/ltrace.git', :sha => 'df8f1ac'

  name 'ltrace'
  version '0.6.0+github2'
  section 'utils'
  description 'ltrace intercepts and records dynamic library calls'

  config_files \
    '/etc/ltrace.conf'

  build_depends \
    'autoconf',
    'automake',
    'libtool',
    'binutils-dev',
    'libelfg0-dev',
    'libunwind7-dev [i386 amd64 ia64]'

  depends \
    'libelfg0',
    'libunwind7'

  def patches
    {:p1 => 'ltrace-libdl-fix.patch'}
  end

  def build
    sh './autogen.sh'
    configure :prefix => prefix, :sysconfdir => etc
    make

    inreplace 'etc/ltrace.conf' do |s|
      s.concat "\n\n"
      s.concat <<-EOC.undent
        ; libmemcached
        void memcached_server_add(addr, string, short);
        addr memcached_create(addr);
        string memcached_get(addr,string,ulong);
        int memcached_set(addr,string,ulong,string,ulong,ulong);

        ; libmysqlclient
        int mysql_real_query(addr,string,ulong);

        ; ruby
        void garbage_collect(void);
      EOC
    end
  end
end
