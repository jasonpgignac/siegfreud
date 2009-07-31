begin
  ThinkingSphinx::Search.search "test" # test search
rescue ThinkingSphinx::ConnectionError
  puts "** Oops! ThinkingSphinx is off! **"
end
