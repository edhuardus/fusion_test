# encoding: utf-8
namespace :import do
  ##
  # Code by Abel Sierra and Eduardo Miramontes
  # Download file csv, txt, XML or Excel in:
  # http://www.sepomex.gob.mx/ServiciosLinea/Paginas/DescargaCP.aspx
  # This code use file csv

  # Code Update by Juan J Lopez
  # Modify to read a file format txt in:
  # http://www.sepomex.gob.mx/ServiciosLinea/Paginas/DescargaCP.aspx
  # Now the code read file txt

  desc "import sepomex data into the DB"
  task :sepomex_data => :environment do
    require 'csv'

    p "- Initializing mass insert of state, municipalities, cities, zip_code and districts #{Time.now}"

    #clean database
    State.delete_all
    Municipality.delete_all
    City.delete_all
    ZipCode.delete_all
    District.delete_all

    @country = Country.find_or_create_by(:iso => 'MX', :name => 'Mexico')

    data    = {}

    # CSV.foreach
    # d_codigo, d_asenta, d_tipo_asenta, D_mnpio, d_estado, d_ciudad, d_CP, c_estado, c_oficina,
    # r[0]    , r[1]    , r[2]         , r[3]   , r[4]    , r[5]    , r[6], r[7]    , r[8]
    
    # c_CP, c_tipo_asenta, c_mnpio, id_asenta_cpcons, d_zona, c_cve_ciudad
    # r[9], r[10]        , r[11]  , r[12]           , r[13] , r[14]

    first_row = true
    #CSV.foreach("#{Rails.root}/vendor/catalogs/sepomex/CPdescarga.csv") do |r|
    CSV.foreach("#{Rails.root}/vendor/catalogs/sepomex/CPdescarga.txt", {:col_sep => '|', :headers => true, :return_headers=> false, encoding: "ISO8859-1", :quote_char => "\x00"}) do |r|
      if first_row
        first_row = false
      else
        #state attributes
        data[r[4]] ||= {}
        if data[r[4]].empty?
          p "Proccessing #{r[4]}"
          data[r[4]][:name] = r[4]
          data[r[4]][:code] = r[7]
        end

        #municipality attributes
        data[r[4]][:municipalities] ||= {}
        data[r[4]][:municipalities][r[3]] ||= {}
        if data[r[4]][:municipalities][r[3]].empty?
          data[r[4]][:municipalities][r[3]][:name] = r[3]
          data[r[4]][:municipalities][r[3]][:code] = r[11]
        end

        #city attributes
        data[r[4]][:municipalities][r[3]][:cities] ||= {}
        data[r[4]][:municipalities][r[3]][:cities][r[5]] ||= {}
        if data[r[4]][:municipalities][r[3]][:cities][r[5]].empty? && !r[5].nil?
          data[r[4]][:municipalities][r[3]][:cities][r[5]][:name] = r[5]
          data[r[4]][:municipalities][r[3]][:cities][r[5]][:code] = r[14]
        end

        #zip_code attributes
        data[r[4]][:municipalities][r[3]][:zip_codes] ||= {}
        data[r[4]][:municipalities][r[3]][:zip_codes][r[0]] ||= {}
        if data[r[4]][:municipalities][r[3]][:zip_codes][r[0]].empty?
          data[r[4]][:municipalities][r[3]][:zip_codes][r[0]][:code] = r[0]
          data[r[4]][:municipalities][r[3]][:zip_codes][r[0]][:city_code] = r[14]
        end

        #district attributes
        data[r[4]][:municipalities][r[3]][:zip_codes][r[0]][:districts] ||= {}
        data[r[4]][:municipalities][r[3]][:zip_codes][r[0]][:districts][r[1]] ||= {}
        if data[r[4]][:municipalities][r[3]][:zip_codes][r[0]][:districts][r[1]].empty?
          data[r[4]][:municipalities][r[3]][:zip_codes][r[0]][:districts][r[1]][:name] = r[1]
        end
      end
    end

    #insert states
    states = []
    data.keys.each do |k|
      states << {:code => data[k][:code], :name => data[k][:name], :country_id => @country.id}
    end
    p "- insert State"
    State.create(states)
    
    #insert municipalities
    municipalities = []
    data.keys.each do |k|
      state = State.find_by(name: k.to_s)
  
      data[k][:municipalities].keys.each do |c|
        municipalities << {:code => data[k][:municipalities][c][:code], :name => data[k][:municipalities][c][:name], :state_id => state.id}
      end
    end
    p "- insert Municipality"
    Municipality.create(municipalities)

    #insert cities
    cities = []
    data.keys.each do |k|
      state = State.find_by(name: k.to_s)
      data[k][:municipalities].keys.each do |c|
        municipality = state.municipalities.find_by(code: data[k][:municipalities][c][:code])
        data[k][:municipalities][c][:cities].keys.each do |z|
          if !data[k][:municipalities][c][:cities][z][:code].nil? && !data[k][:municipalities][c][:cities][z][:name].nil?
            cities << {:code => data[k][:municipalities][c][:cities][z][:code], :name => data[k][:municipalities][c][:cities][z][:name], :municipality_id => municipality.id}
          end
        end
      end
    end
    p "- insert City"
    City.create(cities)

    #insert zip_codes
    zip_codes = []
    data.keys.each do |k|
      state = State.find_by(name: k.to_s)
      data[k][:municipalities].keys.each do |c|
        municipality = state.municipalities.find_by(code: data[k][:municipalities][c][:code])
        data[k][:municipalities][c][:zip_codes].keys.each do |z|
          city_code = data[k][:municipalities][c][:zip_codes][z][:city_code]
          city      = municipality.cities.find_by(code: city_code) unless city_code.blank?
          city_id   = city ? city.id : nil
          zip_codes << {:code => data[k][:municipalities][c][:zip_codes][z][:code], :municipality_id => municipality.id, :city_id => city_id}
        end
      end
    end
    p "- insert ZipCode"
    ZipCode.create(zip_codes)

    #insert districts
    districts = []
    data.keys.each do |k|
      state = State.find_by(name: k.to_s)
      data[k][:municipalities].keys.each do |c|
        municipality = state.municipalities.find_by(code: data[k][:municipalities][c][:code])
        data[k][:municipalities][c][:zip_codes].keys.each do |z|
          zip_code = municipality.zip_codes.find_by(code: data[k][:municipalities][c][:zip_codes][z][:code])
          data[k][:municipalities][c][:zip_codes][z][:districts].keys.each do |d|
            districts << { :name => data[k][:municipalities][c][:zip_codes][z][:districts][d][:name], :zip_code_id => zip_code.id, :municipality_id => municipality.id }
          end
        end
      end
    end
    p "- insert District"
    District.create(districts)

    p "- Successfully completed #{Time.now}\n"
  end

end
