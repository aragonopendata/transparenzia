class PersonalController < ApplicationController
  def index
    @people = Personal.select(:age, :payroll, :triennia, :sex).to_a
  end

end
