Facter.add("perl_installsitebin") do
  setcode do
    Facter::Util::Resolution.exec('/usr/bin/perl -MConfig -e \'print $Config{"installsitebin"};\'')
  end
end
