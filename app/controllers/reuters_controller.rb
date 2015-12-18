require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'AlchemyAPI'

class ReutersController < ApplicationController
# list all
	def overall_ratios
		result = fetch_element_by_css("http://uk.reuters.com/business/quotes/overview?symbol=#{params[:name]}", 'div#overallRatios')		

		respond_to do |format|
			format.xml { render xml: result, status: :ok }
		end
	end

	def chart
		result = fetch_element_by_css("http://uk.reuters.com/business/quotes/overview?symbol=#{params[:name]}", 'div#companyOverviewChart')		

		respond_to do |format|
			format.xml { render xml: result, status: :ok }
		end
	end

	def competitors
		tmp = fetch_element_by_css("http://uk.reuters.com/business/quotes/overview?symbol=#{params[:name]}", 'div.module')

		result = ""
		tmp.each do |node|
			if node.content.include?('Competitors')
				result = node
			end
		end

		respond_to do |format|
			format.xml { render xml: result, status: :ok }
		end
	end	

	def fetch_element_by_css(url, selector)
		page = Nokogiri::HTML(open(url))	 
		page.css(selector)
	end

	#######

	def test
		@result = fetch_element_by_css("http://uk.reuters.com/business/quotes/companyProfile?symbol=#{params[:name]}", "div#companyNews div.moduleBody").to_s
		
		words = Array.new()
		color_hash = Hash.new()
		alchemyapi = AlchemyAPI.new()

		response = alchemyapi.entities('text', @result, { 'sentiment'=>0 })

		if response['status'] == 'OK'
			for entity in response['entities']
				
				if color_hash[entity['type']].nil?
					r = rand(255)
					g = rand(255)
					b = rand(255)

					color_hash[entity['type']] = "#{r}, #{g}, #{b}"
				end

				words << [entity['text'], entity['type'], color_hash[entity['type']]]
			end
		end

		words.each { |word| @result.gsub!(/\b(#{word[0]})\b/i, '<span style="border: 1px solid rgb(' + word[2] + '); padding: 0.2em 0.5em; background-color: rgb(' + word[2] + '); color: white; opacity: 1;">\1</span>')}

		# respond_to do |format|
		# 	format.xml { render xml: @result.html_safe, status: :ok }
		# end
	end
end