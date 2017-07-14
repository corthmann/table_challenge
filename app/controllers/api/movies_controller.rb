module Api
  class MoviesController < ApplicationController

    def index
      @movies = Movie.find_all(**movies_params)
      render json: @movies, status: :ok
    end

    private

    def movies_params
      params.permit(:query, :page, :per_page).symbolize_keys
    end
  end
end
