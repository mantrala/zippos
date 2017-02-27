class ZipsController < ApplicationController
  def index
    @searches = Zippo.recent_user_searches(current_user.id).limit(10)
  end

  def search
    zip = params[:search]
    raise ArgumentError if zip.blank?

    begin
      response = PerformSearch.run(zip, current_user, params[:country])

      if response.blank?
        flash[:notice] = "No zip found"
      elsif response[:error]
        flash[:error] = "We are having trouble find the zip. Please try again!"
      elsif response[:exists]
        flash[:notice] = "User already has the zip: #{zip} saved"
      elsif response[:zippo]
        UserZip.create!(zippo: response[:zippo], user: current_user)
        flash[:success] = "Location details have been saved"
      else
        zippo = Zippo.create!(response)
        UserZip.create!(zippo: zippo, user: current_user)

        flash[:success] = "Location details have been saved"
      end

    rescue ActiveRecord::RecordInvalid => ex
      flash[:error] = ex.record.errors.full_messages
    end

    redirect_to root_path
  end

end
