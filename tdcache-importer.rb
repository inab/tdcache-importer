require "rubygems"
require "bundler"

# require 'dbd-mysql'
require 'mysql'
require "sequel"

require 'memcached'
require 'dalli'

require 'net/http'
require 'net/https'


Bundler.setup

class TD_Cache_Importer
  def initialize
    begin
      @DB = Sequel.connect(:adapter=>'mysql', :host=>'localhost', :database=>'tdcache', :user=>'root')    
      @dc = Dalli::Client.new('localhost:11211')
    rescue Mysql::Error => e_db
      print "Couldn't initiate importer: #{e_db.message}\n"
      exit

    rescue Dalli::RingError => e_cache
      print "Couldn't initiate importer: #{e_cache.message}\n"
      exit
    end
  end


  def get_num_entries
    ds = @DB[:cache]
    begin
      ds.count
    rescue Mysql::Error => e_db
      print "Couldn't access to record count: #{e_db.message}\n"
      exit

    rescue Sequel::DatabaseConnectionError => e_seq
      print "Error on connection to database: #{e_seq.message}\n"
      exit
    end
  end


=begin
for the marshalling/unmarshalling, use
     def marshal(string)
       [Marshal.dump(string)].pack('m*')
     end

     def unmarshal(str)
       Marshal.load(str.unpack("m")[0])
     end
=end  
  def import
    print "Importing #{get_num_entries} cache entries from database into memory...\n"
    i = 0
    modulus_val = (get_num_entries()/100).to_i
    @DB[:cache].each { |row|
      # print "sha2: #{row[:sha2hash]}\n"
      obj_hit = row[:value]
      the_key = row[:thekey]
      unpacked_obj_hit = obj_hit.unpack('m')[0]
      marshald_hit = Marshal.load(obj_hit.unpack('m')[0])
      
      begin
        @dc.set(the_key, marshald_hit)
      rescue Dalli::RingError => e_cache
        print "Couldn't access to memcached server: #{e_cache.message}\n"
        exit
      end

      i=i+1
      if i % modulus_val == 0
        print("#")
      end
    }
  end

end


importer = TD_Cache_Importer.new
# print "Number of entries: #{importer.get_num_entries}\n"
importer.import
print "\n"
