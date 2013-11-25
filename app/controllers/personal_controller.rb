class PersonalController < ApplicationController
  def index
    @people = Personal.all.to_a
  end

end
