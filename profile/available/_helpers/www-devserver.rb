#!/usr/bin/env ruby

# Serve the current directory via HTTP.
# Like Python's SimpleHTTPServer, but with no-cache headers.
# Default port 8000, specify alternate port as first parameter:
#   www 3000
#   sudo www 80 # (probably a bad idea)

# Inspired by http://chrismdp.github.com/2011/12/cache-busting-ruby-http-server/

require "webrick"
require "logger"
require "open3"


## xLogger = Logger.new(STDOUT)


class NonCachingFileHandler < WEBrick::HTTPServlet::FileHandler

	DAY = 86400


	def do_GET(request, response)
		super
		set_no_cache(response)
		set_content_type(response)
	end


	private

	def set_no_cache(response)
		response["Content-Type"]
		response["ETag"]			= nil
		response["Last-Modified"]	= Time.now + DAY
		response["Cache-Control"]	= "no-store, no-cache, must-revalidate, post-check=0, pre-check=0"
		response["Pragma"]			= "no-cache"
		response["Expires"]			= Time.now - DAY
	end


	def set_content_type(response)
		response["Content-Type"] = content_type(response.filename)
	end


	def fix_encoding(enc)
		if ( ( enc =~ %r{^text/}i ) and (not enc.downcase.index("charset=")) )
			if ( enc =~ %r{;\s*$}i )
				enc << " charset=utf-8"
			else
				enc << "; charset=utf-8"
			end
		end
		enc
	end


	def popen_content_type(path)
		begin
			inp, out, err = Open3.popen3("file", "--brief", "--mime-type", path)
			out.read.chomp
		ensure
			inp.close
			err.close
			out.close
		end
	end


	def content_type(path)
##	  xLogger.warn path
		case path.downcase.match(%r{\.(\w+)\z})[1]
		when "html", "htm" then "text/html; charset=utf-8"
		when "asc" then "text/plain"
		when "txt" then "text/plain; charset=utf-8"
		when "js" then "text/javascript; charset=utf-8"
		when "css" then "text/css; charset=utf-8"
		when "json" then "application/json; charset=utf-8"
		when "ico" then "image/x-ico"
		when "png" then "image/png"
		when "gif" then "image/gif"
		when "jpg", "jpe", "jpeg" then "image/jpeg"
		when "bmp" then "image/bmp"
		when "jpg", "jpe", "jpeg" then "image/jpeg"
		when "gif" then "image/gif"
		when "tif", "tiff" then "image/tiff"
		when "rgb" then "image/x-rgb"
		when "atom" then "application/atom+xml"
		when "xht", "xhtm", "xhtml" then "application/xhtml+xml"
		when "xml" then "application/xml"
		when "xslt", "xsl" then "application/xslt+xml"
		when "dtd" then "application/xml-dtd"
		when "atom" then "application/atom+xml"
		when "rss" then "application/rss+xml"
		when "rdf" then "application/rdf+xml"
		when "svg" then "image/svg+xml"
		when "sgm", "sgml" then "text/sgml"
		when "vrml" then "model/vrml"
		when "vxml" then "application/voicexml+xml"
		when "swf" then "application/x-shockwave-flash"
		when "rm" then "application/vnd.rn-realmedia"
		when "avi" then "video/x-msvideo"
		when "mov" then "video/quicktime"
		when "mp4" then "video/mp4"
		when "mpe", "mpeg", "mpg" then "video/mpeg"
		when "mp2", "mp3", "mpga" then "audio/mpeg"
		when "m4a", "m4b", "m4p" then "audio/mp4a-latm"
		when "mid", "midi" then "audio/midi"
		when "wav" then "audio/x-wav"
		when "rtf" then "text/rtf"
		when "rtx" then "text/richtext"
		when "pdf" then "application/pdf"
		when "eps" then "application/postscript"
		when "doc" then "application/msword"
		when "xls" then "application/vnd.ms-excel"
		when "ppt" then "application/vnd.ms-powerpoint"
		when "ics", "ifb" then "text/calendar"
		when "jnlp" then "application/x-java-jnlp-file"
		when "zip" then "application/zip"
		else fix_encoding(popen_content_type(path))
		end
	end

end

## xPort = 

puts "Starting ..."


## WEBrick::HTTPServer.new({ "Port" => ARGV.first || 8000, "AccessLog" => [[xLogger, AccessLog::COMMON_LOG_FORMAT]] }).tap do |server|

WEBrick::HTTPServer.new({ "Port" => ARGV.first || 8000 }).tap do |server|
	server.mount "/", NonCachingFileHandler , Dir.pwd
	trap("INT") { server.stop }
	server.start
end
