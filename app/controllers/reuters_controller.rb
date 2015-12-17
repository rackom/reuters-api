class ReutersController < ApplicationController
# list all
	def find
		page = "<b>"+params[:name]+"</b>"

		respond_to do |format|
			format.xml { render xml: page, status: :ok }
		end
	end
end