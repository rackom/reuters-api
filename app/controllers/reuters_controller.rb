require 'rubygems'
require 'nokogiri'
require 'open-uri'

class ReutersController < ApplicationController
# list all
	def find
		page = Nokogiri::HTML(open("http://uk.reuters.com/business/quotes/overview?symbol=" + params[:name]))   
		result = page.css('div#overallRatios')

		respond_to do |format|
			format.xml { render xml: result, status: :ok }
		end
	end
end