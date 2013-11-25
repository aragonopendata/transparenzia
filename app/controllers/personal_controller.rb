class PersonalController < ApplicationController
  def index
    if params[:modality]
      @people = Personal.where(modality_description: params[:modality])
    else
      @people = Personal.select(:age, :payroll, :triennia, :sex).to_a
    end
  end
end
