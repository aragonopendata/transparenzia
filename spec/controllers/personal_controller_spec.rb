require 'spec_helper'

describe PersonalController do

  context 'GET #index without params' do
    it "should be succesful" do
      get 'index'
      response.should be_success
    end
  end

  context 'GET #index with params[:modality]' do

    it 'returns a list of the people that belong to the selected modality' do
      get 'index', modality: 'Destino+Definitivo'
      response.should be_success
    end
  end

  context 'GET #index with params[:department]' do

    it 'returns a list of the people that belong to the selected department' do
      get 'index', department: 'Destino+Definitivo'
      response.should be_success
    end
  end  
end