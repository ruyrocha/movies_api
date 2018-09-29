class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy]

  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/1
  def show
    json_response(@person)
  end

  # POST /people
  def create
    @person = Person.create!(person_params)

    json_response(@person, status = :created)
  end

  # PATCH/PUT /people/1
  def update
    @person.update!(person_params)
    head :no_content
  end

  # DELETE /people/1
  def destroy
    @person.destroy!
    head :no_content
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def person_params
    params.require(:person).permit(:type, :first_name, :last_name)
  end
end
