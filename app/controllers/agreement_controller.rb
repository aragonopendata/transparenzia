class AgreementController < ApplicationController
  def index
    if params[:year] and params[:year]!=""
      years = params[:year].split("-")
      year_ini = years[0].to_i
      if years.size > 1
        year_end = years[1].to_i
      else
        year_end = year_ini
      end
    else
      year_ini = 2008
      year_end = 2013
    end
    year_ini = Date.new(year_ini, 1, 1)
    year_end = Date.new(year_end, 12, 31)
    
    title = params[:title]? "%#{params[:title]}%": "%"
    signatories = params[:signatories]? "%#{params[:signatories]}%": "%"
    @agreements = Agreement.where(:agreement_date => year_ini..year_end).where("lower(title) like lower(?)", title).where("lower(signatories) like lower(?)", signatories)
    @paginated_agreements = @agreements.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @agreement = Agreement.find params[:id]
  end

  def search
    render json: Signatories.instance.find(params[:term])
  end
end
