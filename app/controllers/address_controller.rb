class AddressController < ApplicationController


  def get_municipalities
    state            = State.find_by(name: params[:state_name])
    @municipalities  = state.municipalities.asc(:name).collect(&:name)

    render :json => @municipalities
  end

  def get_districts
    state        = State.find_by(name: params[:state])
    municipality = state.municipalities.find_by(name: params[:municipality])

    @districts = municipality.districts.asc(:name).collect(&:name)

    render :json => @districts
  end

end