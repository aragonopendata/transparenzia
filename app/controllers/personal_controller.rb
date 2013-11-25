class PersonalController < ApplicationController
  def index
    if params[:modality]
      @people = Personal.where(modality_description: params[:modality])
    else
      @people = Personal.all.to_a
    end
  end

end
