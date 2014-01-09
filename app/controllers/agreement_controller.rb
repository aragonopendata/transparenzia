class AgreementController < ApplicationController
  def index
    year = params[:year] ? params[:year] : "2013"
    @agreements = Agreement.where(:year => year)
  end

  def show
    @agreement = Agreement.find params[:id]
  end
end
