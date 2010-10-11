require 'sha1'
require 'base64'

class Server < LdapBase
  ldap_mapping( :dn_attribute => "puavoId",
                :prefix => "ou=Servers,ou=Hosts",
                :classes => ['top', 'device', 'puppetClient', 'puavoServer', 'simpleSecurityObject'] )

  has_many( :automounts, :class_name => 'Automount',
            :primary_key => 'dn',
            :foreign_key => 'puavoServer' )

  def self.ssha_hash(password)
    salt = ActiveSupport::SecureRandom.base64(16)
    "{SSHA}" + Base64.encode64(Digest::SHA1.digest(password + salt) + salt).chomp!
  end

  def full_hostname
    "#{self.puavoHostname}.#{LdapOrganisation.first.puavoDomain}"
  end

  def id
    self.puavoId.to_s unless self.puavoId.nil?
  end
end
