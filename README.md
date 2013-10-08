Mysql->Memcached Importer
======================================================
The purpose of this script is just to import the entire contents of the cache entries, stored in a database, into a memcached instance

# Requirements
- ruby 1.9.2 or later (supposedly)
- a Mysql server, supposedly with a database (default to tdcache) and a table (default to cache) containing cache entries
- a memcached server running on localhost (by default).


# Overview
The script just restores a persistent cache backup. The cache contains results from remote requests which take long enough to make difficult to use the <a href="http://github.com/inab/tdGUI" target="_blank">Target Dossier</a> application. It is intended to use in this context, although can be used with any other application and the content of the database is not required to have the objects commented.

By default, the database server should be Mysql; the database name is default to 'tdcache' and the table where the cache is persisted is named 'cache' by default. The fields for the key-value hash which is what actually is the database are named 'thekey' and 'value' ('thekey' was chosen to avoid undesirable conflicts with the 'key' sql keyword).

# Usage
First, you must type
			 $ bundle install

from the command line in order to build up the dependencies (gems). Then, just type: 
		 $ ruby tdcache-importer.rb 

to perform the import.
