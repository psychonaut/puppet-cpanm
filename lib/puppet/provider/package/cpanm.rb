require 'puppet/provider/package'

Puppet::Type.type(:package).provide :cpanm, :parent => Puppet::Provider::Package do

  desc 'Install CPAN modules via `cpanm`'

  has_feature :installable, :upgradeable

  confine  :exists => ['/usr/bin/cpanm', '/usr/bin/perldoc']
  commands :cpanm  => '/usr/bin/cpanm'

  # puppet requires an instances method that returns all packages
  # curently installed with this provider.

  # want to try something that is more complete than perllocal

  # Return structured information about all installed Modules
  def self.instances
    packages = Array.new
    pkg_info = Hash.new

    module_name_re = %r{"Module" ((\w+(::)?)+)$}
    module_vers_re = %r{"VERSION: ((\d+\.?)+)}

    # perllocal doesn't always have every module
    # using a custom script that outputs the relevant info in a
    # similar format.  Someone with more ruby knowledge probably could
    # make this better

    list = `perl -MExtUtils::Installed -e '$installed = ExtUtils::Installed->new();printf qq{"Module" %s\n"VERSION: %s"\n},$_,$installed->version($_) for $installed->modules'`
    list.split(/\n/).collect do |line|
      case line
      when module_name_re
        pkg_info = { :name => $1, :provider => name }
      when module_vers_re
        pkg_info[:ensure] = $1
        packages << new(pkg_info)
      else
        next
      end
    end
    debug packages.inspect
    return packages
  end

  # Return structured information about a particular module
  def query
    self.class.instances.each do |pkg|
      return pkg.properties if pkg.name == @resource[:name]
    end
    return nil
  end

  # Install the module
  def install
    cpanm @resource[:name]
  end

  # update the module 
  def update
      cpanm @resource[:name]
  end

  # Return the latest available version of a particular module
  def latest
    dist_re     = %r{(.*?)(\w+-?)+((\d+\.?)+)\.(\w+\.?)+}
    latest_dist = %x{/usr/bin/cpanm --info #{@resource[:name]}}
    if latest_dist =~ dist_re
      $3
    else
      nil
    end
  end
end

