class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @ratings = %w{G PG PG-13 R}



    redirection = false
# see if user wants to reset
    if params[:reset]
      session.clear
      return redirect_to movies_path
    end
#see if rating passed as parameter
    if params[:ratings]
      @ratings = params[:ratings].keys
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirection = true
    end    
    session[:ratings] = @ratings

    @all_ratings = %w{G PG PG-13 R}
    @sortbythis = {}

    @sortby = nil
#see if sort is passed as parameter
    if params[:sort]
      @sortby = params[:sort]
    elsif session[:sort]
      @sortby = session[:sort]
      redirection = true
    end

    session[:sort] = @sortby


    @movies = Movie.get_allratings(@ratings)
    if @sortby
      @movies = @movies.order(@sortby)
      @sortbythis[@sortby] = 'hilite'
    end

    if redirection
      return redirect_to movies_path(
        :ratings => Hash[@ratings.collect { |item| [item, 1] } ],
        :sort => @sortby)
    end
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
