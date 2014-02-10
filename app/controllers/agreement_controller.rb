class AgreementController < ApplicationController
  def index
    @agreements = Agreement.between_dates(params[:year_ini].to_i,params[:year_end].to_i)
      .valid(params[:validity_date])
      .invalid(params[:validity_date])
      .find_by_title(params[:title])
      .find_by_signatories(params[:signatories])
      .find_by_section(params[:section])
      .order_by(params[:type])
    @paginated_agreements = @agreements.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @agreement = Agreement.find params[:id]
  end

  def search
    render json: Signatories.instance.find(params[:term])
  end
end
