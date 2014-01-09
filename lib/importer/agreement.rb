require 'json'
require 'iconv'

class AgreementImporter
  attr_accessor :keys, :data
  @keys
  @data
  def initialize(doc)
    i = Iconv.new('UTF-8','LATIN1')
    doc = i.iconv(doc)
    doc = doc.gsub('`','')
    @data = JSON.parse(doc)
    @keys = @data.first.keys
  end

  def save
    Agreement.destroy_all(:year => @data.first['Año'])
    @data.each do |item|
      begin
        agreement = Agreement.new(
            :code => item['Número'],
            :year => item['Año'], 
            :section => item['Sección'], 
            :title => item['Título'], 
            :agreement_date => convert_text_to_date(item['FechaAcuerdo']),
            :signature_date => convert_text_to_date(item['FechaFirma']),
            :validity_date => convert_text_to_date(item['FechaVigencia']), 
            :signatories => item['Firmantes'], 
            :dga_contribution => item['AportacionDGA'], 
            :another_contributions => item['OtrasAportaciones'],
            :amount => item['Cuantia'],
            :addendums => item['Addendas'],
            :observations => item['Observaciones'],
            :notes => item['Notasmarginales'],
            :pdf_url => item['UrlPdf']
          )
        agreement.save!
      rescue Exception => e
        puts "Error for #{item}"
        raise e
      end
    end
  end

  def convert_text_to_date(text)
    begin
      date = (text!="") ? Date.strptime(text, "%Y%m%d"): nil
    rescue
      date = nil
    end
    if date and date.gregorian?
      date
    end
  end
end