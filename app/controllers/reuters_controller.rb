class ReutersController < ApplicationController
# list all
	def find
		respond_to do |format|
			format.xml { render xml: "<b>"+params[:name]+"</b>", status: :ok }
		end
	end
end