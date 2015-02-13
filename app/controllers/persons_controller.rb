class PersonsController < ApplicationController

  before_filter :authenticate_user!



  def index
    @persons = Person.all
  end

  def new
    @person = Person.new

    buil_address
  end

  def create
    @person = Person.new
    @person.attributes = params[:person]

    if @person.save
      redirect_to person_path(@person)
    else
      buil_address
      render 'new'
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  def buil_address
    # address
    @person.build_address if @person.address.nil?
    @address                = @person.address
    @nested_address         = 'person[address]'
  end

end