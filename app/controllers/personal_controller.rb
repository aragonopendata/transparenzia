class PersonalController < ApplicationController
  def index
    @people = Personal.select(:age, :payroll, :triennia, :sex)
    @people = @people.where(modality_description:   params[:modality])   if params[:modality].present?
    @people = @people.where(department_description: params[:department]) if params[:department].present?
  end
end
