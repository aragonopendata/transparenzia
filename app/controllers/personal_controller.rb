class PersonalController < ApplicationController
  def index
    @people = Personal.select(:age, :payroll, :triennia, :sex)
    @people = @people.by_modality(params[:modality])  if params[:modality].present?
    @people = @people.by_department(params[:department]) if params[:department].present?
  end
end
