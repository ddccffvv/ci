require "nokogiri"
require "open-uri"


URL = "http://localhost"

puts "--Start docker container"
#puts `docker start lamp2`

#sleep 5


page = Nokogiri::HTML(open(URL))
forms = page.css("form")

puts "Found #{forms.length} forms. Doing the necessary..."

forms.each_with_index do |form, index|
	puts "Looking at form #{index + 1}"
	action = form[:action]
	fields = form.css("input").map{|i| i["name"]}
	puts "--Preparing target and injection string"
	puts "target: #{URL}/#{action}"
	injection_string = ""
	fields.each do |p|
		injection_string += p + "=a&"
	end

	injection_string = injection_string.gsub(/\&$/, '')
	puts "sample data: #{injection_string}"


	puts "--Feeding this to sqlmap. This might take a while"
	#purging sqlmap state
	`./sqlmap-dev/sqlmap.py --purge-output`
	output = `./sqlmap-dev/sqlmap.py --data "#{injection_string}" -u #{URL}/#{action} -v 0 --batch --disable-coloring`
	output.split("\n").each do |line|
		match = line.match(/.*parameter \'(.*)\' is vulnerable/i)
		if match
			puts "SQL injection detected: "
			puts match.captures[0]
			exit 1
		end
	end


end


puts "code is safe"
exit 0
