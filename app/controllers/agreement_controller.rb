class AgreementController < ApplicationController
  def index
    year = params[:year] ? params[:year] : "2013"
    title = params[:title]? "%#{params[:title]}%": "%"
    signatories = params[:signatories]? "%#{params[:signatories]}%": "%"
    @agreements = Agreement.where(:year => year).where("lower(title) like lower(?)", title).where("lower(signatories) like lower(?)", signatories)
  end

  def show
    @agreement = Agreement.find params[:id]
  end
end
