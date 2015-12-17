require 'rubygems'
require 'nokogiri'
require 'open-uri'

class ReutersController < ApplicationController
# list all
	def overall_ratios
		result = fetch_element_by_css('div#overallRatios')		

		respond_to do |format|
			format.xml { render xml: result, status: :ok }
		end
	end

	def chart
		result = fetch_element_by_css('div#companyOverviewChart')		

		respond_to do |format|
			format.xml { render xml: result, status: :ok }
		end
	end

	def competitors
		tmp = fetch_element_by_css('div.module')

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

	def fetch_element_by_css(selector)
		page = Nokogiri::HTML(open("http://uk.reuters.com/business/quotes/overview?symbol=" + params[:name]))   
		page.css(selector)
	end
end