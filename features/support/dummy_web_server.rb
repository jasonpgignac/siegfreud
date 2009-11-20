module DummyWebServer
  require 'socket'
  port = ARGV[0]
  folder = ARGV[1]
  if port && folder
    unless FileTest::directory?(folder)
      FileUtils.makedirs(folder)
    end
    
    webserver = TCPServer.new('127.0.0.1', ARGV[0])
    while (session = webserver.accept)
      session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
      request = session.gets
      puts request
      trimmedrequest = request.gsub(/GET\ /,'').gsub(/\ HTTP.*/, '').gsub(/^http(s?):\/\/localhost:....\//,'').gsub(/^\//,'')
      filename = trimmedrequest.chomp
      if filename == ""
        filename = "index.html"
      end
      filename = "#{folder}/#{filename}"
      begin
        displayfile = File.open(filename, 'r')
        content = displayfile.read()
        session.print content
      rescue Errno::ENOENT
        session.print "File not found: #{filename}"
      end
      session.close
      
    end
  end
end