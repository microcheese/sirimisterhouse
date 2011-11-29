require 'cora'
require 'siri_objects'
require 'net/http'
require 'socket'      # Sockets are in standard library
require 'rexml/document'

#######
# This is a "hello world" style plugin. It simply intercepts the phrase "text siri proxy" and responds
# with a message about the proxy being up and running (along with a couple other core features). This 
# is good base code for other plugins.
# 
# Remember to add other plugins to the "config.yml" file if you create them!
######

class SiriProxy::Plugin::Misterhouse < SiriProxy::Plugin
  def initialize(config)
    #if you have custom configuration options, process them here!
  end


  listen_for /Licht/i do |commanddata|
	operation = "Undefiniert"
	status = "Undefiniert"
	if(commanddata.match(/An/i) || commanddata.match(/Ein/i))
		kommando="on"
		operation = "An"
	elsif(commanddata.match(/Aus/i))
		kommando="off"
		operation = "Aus"
	elsif(commanddata.match(/Status/i))
		kommando="status"
	end

	puts "[MH] Switch #{kommando}" 

	raum = "Undefiniert"
	if(command.match(/Wohnzimmer/i))
		status = misterhouse_switch_xml("Licht_WZ_Stehlampe", kommando)
		raum = "Wohnzimmer"
	elsif(command.match(/Gang/i))
		status = misterhouse_switch_xml("Licht_Gang", kommando)
		raum = "Gang"
	elsif(command.match(/Bad/i))
		status = misterhouse_switch_xml("Dimmer_Bad", kommando)
		raum = "Bad"
	elsif(command.match(/Billiardzimmer/i))
		status = misterhouse_switch_xml("Licht_Billiardzimmer", kommando)
		raum = "Billiardzimmer"
	elsif(command.match(/Büro/i))
		status = misterhouse_switch_xml("Licht_Buero", kommando)
		raum = "Büro"
	elsif(command.match(/Kleiderschrank/i))
		status = misterhouse_switch_xml("Licht_Kleiderschrank", kommando)
		raum = "Kleiderschrank"
	elsif(command.match(/Klo/i))
		status = misterhouse_switch_xml("Licht_Klo", kommando)
		raum = "Klo"
	elsif(command.match(/Schlafzimmer/i))
		status = misterhouse_switch_xml("Licht_Schlafzimmer", kommando)
		raum = "Schlafzimmer	"
	elsif(command.match(/Treppenzimmer/i))
		status = misterhouse_switch_xml("Licht_Treppenzimmer", kommando)
		raum = "Treppenzimmer"
	elsif(command.match(/Obergeschoss/i))
		misterhouse_switch_xml("Licht_Gang", kommando)
		misterhouse_switch_xml("Dimmer_Bad", kommando)
		misterhouse_switch_xml("Licht_Billiardzimmer", kommando)
		misterhouse_switch_xml("Licht_Buero", kommando)
		misterhouse_switch_xml("Licht_Kleiderschrank", kommando)
		misterhouse_switch_xml("Licht_Klo", kommando)
		misterhouse_switch_xml("Licht_Schlafzimmer", kommando)
		misterhouse_switch_xml("Licht_Treppenzimmer", kommando)
		raum = "Obergeschoss"
	end
	puts "[MH] Switch #{raum}" 
	
	if (kommando.match(/status/i))
		say "Das Licht im #{raum} ist #{operation}"
	else
		say "Schalte Licht im #{raum} #{operation}"
	end
	request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  def misterhouse_switch_xml(objekt,command)
	puts "[MH] Switch XML" 
	status = "unknown"

	if (command.match(/Status/i))
		aktion = "get"
	else
		aktion = "set"
	end

	# Hier Misterhouse commando
	s = TCPSocket.open('localhost', 8899)
	# s.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, 2)
	s.puts "<MisterhouseXML><Action><Type>#{aktion}</Type><Item>$#{objekt}</Item><Value>#{command}</Value></Action></MisterhouseXML>"
			
	puts "[MH] Vor Data Receive" 
	data=s.recv(200)	
	puts "[MH] #{data} "

	if (data.match(/\<\/MisterhouseXML/i))
		puts "[MH] Process XML"
		# extract event information
		doc = REXML::Document.new(data)
		doc.elements.each('MisterhouseXML/Response/Value') do |ele|
			status = ele.text
		end
		if (status.match(/on/i))
			status = "An"
		elsif (status.match(/off/i))
			status = "Aus"
		end
	end

	puts "[MH] Nach Data Receive" 

	s.close               # Close the socket when done
      	return "#{status}"
  end

end