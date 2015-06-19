

puts "--Start docker container"
puts `docker start lamp2`

sleep 5

puts "--Downloading the vulnerable form"
puts `wget 127.0.0.1`

puts "--Parsing form for variables"
action = nil
params = []
File.open("index.html").each do |line|
	match = line.match(/.*\<form.*action=\"(.*)\"/i)
	if match
		puts "Found form action: "
		puts match.captures[0]
		action = match.captures[0]
	end
	match = line.match(/.*\<input.*name=\"(.*)\" /i)
	if match
		splitted = match.captures[0].split '"'
		if not splitted[0] == "Submit"
			puts "Found form parameter: "
			puts splitted[0]
			params.push splitted[0]
		end
		
	end
end

puts "--Preparing target and injection string"
puts "target: 127.0.0.1/#{action}"
injection_string = ""
params.each do |p|
	injection_string += p + "=a&"
end

injection_string = injection_string.gsub(/\&$/, '')
puts "sample data: #{injection_string}"


puts "--Feeding this to sqlmap. This might take a while"
#purging sqlmap state
`./sqlmap-dev/sqlmap.py --purge-output`
output = `./sqlmap-dev/sqlmap.py --data "#{injection_string}" -u 127.0.0.01/#{action} -v 0 --batch --disable-coloring`
output.split("\n").each do |line|
	if line =~ /.*parameter.*is vulnerable./
		puts "sqlinjection detected"
		exit
	end
end
puts "code is safe"
