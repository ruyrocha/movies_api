class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :update, :destroy]

  # GET /movies
  def index
    @movies = Movie.all
  end

  # GET /movies/1
  def show
    json_response(@movie)
  end

  # POST /movies
  def create
    @movie = Movie.create!(movie_params)

    json_response(@movie, status = :created)
  end

  # PATCH/PUT /movies/1
  def update
    @movie.update!(movie_params)

    head :no_content
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy

    head :no_content
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.includes(:roles, :people).find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def movie_params
    params.require(:movie).permit(:title, :release_date)
  end
end
